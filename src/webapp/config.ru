require "sinatra"
require "yaml"

require_relative "lib/api"

config = YAML.load_file(ENV.fetch("CONFIG_FILE"))

run Api.new(config)
