require 'barrister-redis'
require './service.rb'

container = Barrister::RedisContainer.new('./user_service.json', ENV['OPENREDIS_URL'] || 'redis://localhost:6379', 'foo_bar', [UserService])
container.start
