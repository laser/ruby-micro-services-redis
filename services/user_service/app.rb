require 'active_record'
require 'barrister'
require 'pry'
require 'redis'
require 'erb'

# App
require './models.rb'
require './service.rb'

dbconfig = YAML.load(ERB.new(File.read(ENV['DB_YML_PATH'])).result)
RACK_ENV ||= ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.establish_connection(dbconfig[RACK_ENV])

contract = Barrister::contract_from_file('./user_service.json')
server   = Barrister::Server.new(contract)
server.add_handler('UserService', UserService.new)

list_name = 'user_service'
client = Redis.new

while true
  # pop last element off our list in a blocking fashion
  channel, request = client.brpop(list_name)

  parsed = JSON.parse request

  # reverse the message we were sent
  response = {
    'message' => server.handle(parsed['message'])
  }

  # 'respond' by inserting our reply at the head of a 'reply'-list
  client.lpush(parsed['reply_to'], JSON.generate(response))
end
