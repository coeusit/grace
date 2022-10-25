require 'sequel'
require 'redis'

$DB = Sequel.connect(:adapter => 'mysql2', :host => ENV.fetch("MYSQL_HOST"), :database => ENV.fetch("MYSQL_DATABASE"), :user => ENV.fetch("MYSQL_USER"), :password => ENV.fetch("MYSQL_PASSWORD"))

Dir['./lib/common/db/orm/*.rb'].each { |file| require file }
