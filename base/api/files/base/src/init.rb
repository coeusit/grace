require 'yaml'
YAML.load_file('./modules.yml').each do |_m|
  require _m
end

_server = Server.new
_server.run({ :host => '0.0.0.0', :port => 80 })
