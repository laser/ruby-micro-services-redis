require 'barrister-redis'
require 'erb'

# App
require './models.rb'
require './service.rb'

redis_config = YAML.load(ERB.new(File.read('../../config/redis.yml')).result)['default']
json_path    = './user_service.json'
database_url = ENV['OPENREDIS_URL'] || redis_config['database_url']
list_name    = redis_config['list_name']
handlers     = { 'UserService' => UserService }

container = Barrister::Containers::Redis.new(json_path, database_url, list_name, handlers)
container.start
