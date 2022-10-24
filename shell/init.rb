require 'yaml'
require 'faker'
require 'securerandom'
require 'fileutils'
require 'logger'
require 'highline/import'


$config = YAML.load_file("#{$basepath}/grace.yml")
@logger = Logger.new(STDOUT)
@args = ARGV
cmd = @args.shift.split(':').join('/')

def require_project_root
  if File.exist?("#{Dir.pwd}/docker-compose.yml")
    return true
  else
    @logger.error 'You need to perform this command from the root of a Grace project'
    return false
  end
end

if cmd != nil
  puts "CMD::#{cmd}"
  if File.file?("#{$basepath}/shell/cmd/#{cmd}.rb")
    require "#{$basepath}/shell/cmd/#{cmd}.rb"
  end
else
  @logger.error 'No command given'
end
