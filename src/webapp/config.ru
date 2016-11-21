require "bundler/setup"
require "sinatra"

class WebApp < Sinatra::Base
  get "/" do
    "Running happily in a BOSH deployment"
  end
end

run WebApp
