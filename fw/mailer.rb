require 'net/smtp'
require 'json'
require 'faker'
require 'redis'

class Mailer
  @_redis = nil
  def parse_template(_tmpl)
    return {
      subject: _tmpl.subject,
      sender_address: _tmpl.sender_address,
      content_html: _tmpl.content_html,
      content_plain: _tmpl.content_plain
    }
  end
  def get_template(_name)
    _template = @_redis.get("mailer/template/#{_name}")
    if _template == nil
      _tmpl = EmailTemplate.where(:name => _name).first
      if _tmpl == nil
        return nil
      else
        _template = parse_template(_tmpl)
        cache_template("mailer/template/#{_name}", _template)
        return _template
      end
    else
      return JSON.parse(_template)
    end
  end
  def cache_template(_name, _contents)
    @_redis.set("mailer/template/#{_name}", JSON.generate(_contents))
  end
  def set_template(_name, _tmpl)
    EmailTemplate.update_or_create({ name: _name }, _tmpl)
    cache_template("mailer/template/#{_name}", _tmpl)
  end
  def initialize
    @_redis = Redis.new(url: ENV.has_key?('REDIS_HOST') ? ENV['REDIS_HOST'] : 'redis://redis:6379/0')
  end
  def send_message(_opt = {})
    logger = Logger.new(STDOUT)
    if (_opt[:sender] != nil || ENV.has_key?('SMTP_SENDER')) && (_opt[:from] != nil || ENV.has_key?('SMTP_FROM')) && _opt[:to] != nil && (_opt[:message_plain] || _opt[:message_html]) && _opt[:subject] != nil
      _parts = []
      _marker = Faker::Crypto.md5.upcase
      _part_header =<<EOS
From: #{(_opt[:from] != nil ? _opt[:from] : ENV['SMTP_FROM'])}
To: #{_opt[:to]}
Subject: #{_opt[:subject]}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{_marker}
--#{_marker}
EOS
      _parts << _part_header
      if _opt[:message_html] != nil
        _part_html =<<EOS
Content-Type: text/html
Content-Transfer-Encoding: 8bit

#{_opt[:message_html]}
EOS
        _parts << _part_html
      end
      if _opt[:message_plain] != nil
        _part_html =<<EOS
Content-Type: text/plain
Content-Transfer-Encoding: 8bit

#{_opt[:message_plain]}
EOS
        _parts << _part_html
      end
      _msg = _parts.join
      _smtp = Net::SMTP.new(ENV['SMTP_SERVER'], ENV['SMTP_PORT'])
      _smtp.start(ENV['SMTP_DOMAIN']) do |smtp|
        _smtp.send_message _msg, (_opt[:sender] != nil ? _opt[:sender] : ENV['SMTP_SENDER']), _opt[:to]
      end
    end
  end
end
