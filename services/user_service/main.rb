#!/usr/bin/env ruby

require 'barrister-redis'
require './implementation.rb'

container = Barrister::RedisContainer.new('./interface.json', UserService.new, database_url: ENV['OPENREDIS_URL'] || 'redis://localhost:6379', list_name: 'user_service')
container.start
