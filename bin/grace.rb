$binpath = File.dirname(__FILE__)
$basepath = File.expand_path('..', $binpath)

puts "Directory: #{$binpath}"
require "#{$binpath}/../shell/init.rb"
