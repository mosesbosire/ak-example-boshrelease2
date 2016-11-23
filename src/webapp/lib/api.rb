require "sinatra"
require "redis"
require "json"

class RedisFactory
  def self.redis(config)
    opts = {
      host: config["redis"]["host"],
      port: config["redis"]["port"],
    }

    pw = config["redis"].fetch("password", "")
    opts[:password] = pw unless pw.empty?

    Redis.new(opts)
  end
end


class Api < Sinatra::Base
  def initialize(config)
    @@config = config
    super()
  end

  set :config, -> { @@config }
  set :storage, -> { RedisFactory.redis(@@config) }

  if ENV["RACK_ENV"] == "test"
    set :raise_errors, true
    set :dump_errors, false
    set :show_exceptions, false
  end

  get "/" do
    "Running happily in a BOSH deployment"
  end

  get "/storage/:key" do
    redis = settings.storage
    redis.get(params[:key]).to_json
  end

  post "/storage/:key" do
    redis = settings.storage
    redis.set(params[:key], JSON.parse(request.body.read)["value"])
    ""
  end

  delete "/storage/:key" do
    redis = settings.storage
    redis.del(params[:key])
    ""
  end
end
