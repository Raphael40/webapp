require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/names' do
    return "Julia, Mary, Karim"
  end

  post '/sort-names' do
    names = params[:names]

    return names.split(",").sort.join(",")
  end
end