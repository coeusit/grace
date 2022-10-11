require 'yaml'
require 'faker'
require 'securerandom'
require 'fileutils'
require 'logger'
require 'highline/import'

$config = YAML.load_file("#{$basepath}/grace.yml")
@logger = Logger.new(STDOUT)
@args = ARGV
cmd = @args.shift

if cmd != nil
  if File.file?("#{$basepath}/shell/cmd/#{cmd}.rb")
    require "#{$basepath}/shell/cmd/#{cmd}.rb"
  end
else
  @logger.error 'No command given'
end
