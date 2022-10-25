require logger
class MLog
  def info(msg)
    Logger.new(STDOUT).info msg
    Logger.new("./log/#{ENV['RUBY_ENV']}.log", 10, 1024000).info msg
  end
  def warning(msg)
    Logger.new(STDOUT).warning msg
    Logger.new("./log/#{ENV['RUBY_ENV']}.log", 10, 1024000).warning msg
  end
  def error(msg)
    Logger.new(STDOUT).error msg
    Logger.new("./log/#{ENV['RUBY_ENV']}.log", 10, 1024000).error msg
  end
end
