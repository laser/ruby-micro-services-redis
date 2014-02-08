require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'active_record'
require 'barrister'
require 'pry'

# App
require './models.rb'

dbconfig = YAML.load(ERB.new(File.read(ENV['DB_YML_PATH'])).result)
RACK_ENV ||= ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.establish_connection(dbconfig[RACK_ENV])

class UserService
  USER_PROPERTIES = %w(id full_name email phone_number)

  def get_all_users()
    User.all.map &method(:to_user_properties)
  end

  def get_user_by_id(id)
    to_user_properties User.find(id)
  end

  def delete_user_by_id(id)
    !!User.destroy(id)
  end

  def update_user_by_id(id, user_properties)
    to_user_properties(User.update(id, user_properties))
  end

  def create_user(user_properties)
    to_user_properties(User.create(user_properties))
  end

private
  def to_user_properties(user)
    user.serializable_hash.slice *USER_PROPERTIES
  end
end

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
