require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'active_record'
require 'barrister'
require 'pry'

# App
require './models.rb'
require './service.rb'

dbconfig = YAML.load(ERB.new(File.read(ENV['DB_YML_PATH'])).result)
RACK_ENV ||= ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.establish_connection(dbconfig[RACK_ENV])

contract = Barrister::contract_from_file('./user_service.json')
server   = Barrister::Server.new(contract)
server.add_handler('UserService', UserService.new)

post '/user_service' do
  request.body.rewind
  resp = server.handle_json(request.body.read)

  status 200
  headers 'Content-Type' => 'application/json'
  resp
end
