require 'barrister-redis'
require './service.rb'

container = Barrister::RedisContainer.new('./user_service.json', UserService.new, database_url: ENV['OPENREDIS_URL'] || 'redis://localhost:6379', list_name: 'foo_bar')
container.start
