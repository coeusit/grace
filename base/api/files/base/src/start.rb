require 'logger'
if ENV['RUBY_ENV'] == 'development'
  logger = Logger.new(STDOUT)
  logger.info 'Grace container on standby for development'
  while true do

  end
else
  require './init.rb'
end
