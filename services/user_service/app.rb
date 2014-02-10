require 'active_record'
require 'barrister'
require 'pry'
require 'redis'
require 'erb'

# App
require './models.rb'
require './service.rb'

# establish connection to main db
db_config = YAML.load(ERB.new(File.read('../../config/database.yml')).result)
RACK_ENV ||= ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.establish_connection(db_config[RACK_ENV])

# establish connection to Redis
redis_config = YAML.load(ERB.new(File.read('../../config/redis.yml')).result)
client = Redis.connect url: redis_config['user_service']['database_url']

# initialize service
contract = Barrister::contract_from_file('./user_service.json')
server   = Barrister::Server.new(contract)
server.add_handler('UserService', UserService.new)

while true
  # pop last element off our list in a blocking fashion
  channel, request = client.brpop(redis_config['user_service']['list_name'])

  parsed = JSON.parse request

  # reverse the message we were sent
  response = {
    'message' => server.handle(parsed['message'])
  }

  # 'respond' by inserting our reply at the head of a 'reply'-list
  client.lpush(parsed['reply_to'], JSON.generate(response))
end
