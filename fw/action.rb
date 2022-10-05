class Action
  @response = false
  def initialize(_opt = {})
    _opt.each {|k,v|
      instance_variable_set("@#{k.to_s}", v)
    }
  end
  def execute(_code)
    begin
      eval(_code)
    rescue Exception => e
      if ENV['RUBY_ENV'] == 'development'
        logger = Logger.new(STDOUT)
        logger.error "Failure executing action: #{e}"
        @response = {
          :action => 'server_error',
          :response => e
        }
      else
        @response = {
          :action => 'server_error',
          :response => 'An error occurred on the server'
        }
      end
    end
    return @response
  end
end
