require 'yaml'
require 'amqp'
require 'json'
require 'base64'
require 'em-websocket'
require 'google/cloud/storage'
require 'rotp'
require 'logger'
require 'filewatcher'
require 'thin'
require './lib/fw/session.rb'

def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end

class Server
  @_amqp_exchange = nil
  @config = {}
  @@_sessions = {}
  def reload_actions
    logger = Logger.new(STDOUT)
    logger.info 'Loading actions'
    clear_actions
    Dir.glob('./lib/common/init/**/*.rb').each do |file|
      eval(File.open(file).read)
    end
    Dir.glob('./init/**/*.rb').each do |file|
      eval(File.open(file).read)
    end
  end
  def load_schema
    logger = Logger.new(STDOUT)
    @_schemas = {}
    logger.info 'Loading schema'
    Dir.glob('./lib/common/schema/**/*.yml').each do |file|
      @_schemas[file[10..-4]] = YAML.load_file(file)
    end
  end
  def clear_actions
    @_actions = {}
    @_plugins = {}
  end
  def add_action(_key, _class, _content = nil)
    @_actions[_key] = {
      :class => _class,
      :content => _content
    }
  end
  def add_plugin(_key, _content = nil)
    @_plugins[_key] = _content
  end
  def get_session(_sid)
    return @@_sessions[_sid]
  end
  def interpret_message(opt = {})
    # _msg, _sid
    msg = opt.has_key?(:msg) ? opt[:msg] : {}
    session = nil
    if opt.has_key?(:sid)
      session = get_session(opt[:sid])
    elsif opt.has_key?(:session_id) && opt.has_key?(:session_key)
      session = Session.new(session_id: opt[:session_id], session_key: opt[:session_key])
    else
      session = Session.new
    end
    response = false
    _data = {}
    if msg.has_key?('data')
      _data = msg['data']
    end
    _opt = {
      params: _data
    }
    @_plugins.each {|k,v|
      _opt[k] = eval(v)
    }
    if @_actions.has_key?(msg['action'])
      action = @_actions[msg['action']][:class].new(_opt)
      if ENV['RUBY_ENV'] == 'development'
        logger = Logger.new(STDOUT)
        logger.info "Calling action: #{msg['action']}"
      end
      if @_actions[msg['action']][:content] == nil
        response = action.execute
      else
        response = action.execute(@_actions[msg['action']][:content])
      end
    end
    return response
  end
  def start_filewatcher
    if ENV['RUBY_ENV'] == 'development'
      logger = Logger.new(STDOUT)
      logger.info 'Initializing filewatcher'
      filewatcher = Filewatcher.new(['./actions','./lib/common/actions','./init','./lib/common/init'])
      Thread.new(filewatcher) { |fw| fw.watch { reload_actions } }
      filewatcher = Filewatcher.new('./lib/common/schema')
      Thread.new(filewatcher) { |fw| fw.watch { load_schema } }
      logger.info 'Filewatcher initialized'
    end
  end
  def init_amqp
    if ENV.has_key?('AMQP_HOST')
      logger = Logger.new(STDOUT)
      logger.info 'Subscribing to AMQP'
      _amqp_connection = AMQP.connect(:host => ENV['AMQP_HOST'])
      _amqp_ch = AMQP::Channel.new(_amqp_connection)
      _amqp_queue = _amqp_ch.queue('control.api', :auto_delete => true)
      @_amqp_exchange = _amqp_ch.default_exchange
      _amqp_queue.subscribe do |_meta, _payload|
        _msg = JSON.parse(_payload)
        #if _data.is_a?(Hash) && _msg.has_key?('action') != nil
        #  _data = _msg.has_key?('data') ? _msg['data'] : nil
        #  _response = false
        #  if @_actions.has_key?(_msg['action'])
        #    _action = @_actions[_msg['action']][:class].new(params: _data)
        #    if @_actions[_msg['action']][:content] == nil
        #      _action.execute
        #    else
        #      _action.execute(@_actions[_msg['action']][:content])
        #    end
        #  end
        #  if _response != false
        #    @ch.push _response
        #  end
        #end
      end
    end
  end
  def load_config
    logger = Logger.new(STDOUT)
    logger.info "Loading config"
    @config = YAML.load_file('./config/grace.yml')
  end
  def run(_server_options)
    EM.run do
      logger = Logger.new(STDOUT)
      logger.info "Initializing Grace server in #{ENV['RUBY_ENV']} mode"
      load_config
      init_amqp
      load_schema
      start_filewatcher
      reload_actions

      logger.info 'Initializing EM channel'
      $ch = EM::Channel.new
      if @config['server'] == 'websocket'
        logger.info 'Initializing websocket server'
        if ENV['RUBY_ENV'] == 'development' || !File.file?('./ssl/privkey.pem') || !File.file?('./ssl/privkey.pem')
          emws_opt = {
            :host => '0.0.0.0',
            :port => 80
          }
        else
          emws_opt = {
            :host => '0.0.0.0',
            :port => 80,
            :secure => true,
            :tls_options => {
              :private_key_file => './ssl/privkey.pem',
              :cert_chain_file => './ssl/fullchain.pem'
            }
          }
        end
        EM::WebSocket.start(emws_opt) do |_ws|
          _ws.onopen { |handshake|
            logger = Logger.new(STDOUT)
            sid = $ch.subscribe do |_cm|
              _session = get_session(sid)
              if _session != nil && _session.authenticated
                if _cm.has_key?(:user_id) && _cm[:user_id] == _session.user_id
                  _ws.send JSON.generate(_cm[:message])
                end
              end
            end
            logger.info "Connection opened [#{sid}]"
            @@_sessions[sid] = Session.new(sid: sid)
            _ws.onclose {
              @@_sessions.delete(sid)
              logger.info "Connection closed [#{sid}]"
            }
            _ws.onmessage { |msg|
              _session = get_session(sid)
              if ENV['RUBY_ENV'] == 'development'
                logger.info "Received message: " + msg.inspect
              end
              if valid_json?(msg)
                parsed_message = JSON.parse(msg)
                response = interpret_message(msg: parsed_message, sid: sid)
                if response != false
                  if response.class == Hash
                    _ws.send(JSON.generate(response))
                  elsif response.class == Array
                    response.each do |response_message|
                      _ws.send(JSON.generate(response_message))
                    end
                  end
                end
              end
            }
          }
        end
        logger.info 'Server initialized'
      elsif @config['server'] == 'rest'
        logger.info 'Initializing REST server'
        dispatch = Rack::Builder.app do
          map '/' do
            run HttpSrv.new
          end
        end
        Rack::Server.start({
          app:    dispatch,
          server: 'thin',
          signals: false,
          Host:   '0.0.0.0',
          Port:   80
        })
        logger.info 'Server initialized'
      else
        logger.error 'No server defined'
        EM.stop
      end
    end
  end
end
