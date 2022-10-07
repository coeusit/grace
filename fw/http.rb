require 'sinatra/base'

class HttpSrv < Sinatra::Base
  configure do
    set :threaded, true
  end
  get '/' do
    body 'Lorem ipsum'
  end
end
