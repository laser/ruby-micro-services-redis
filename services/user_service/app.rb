require 'sinatra'
require 'sinatra/activerecord'
require 'barrister'
require 'pry'

set :database, "sqlite3:///user_service.sqlite3"

class User < ActiveRecord::Base
  attr_accessor :full_name, :id, :phone_number, :email
end

class UserService
  def create_user(user_properties)
    user = User.new user_properties
    user.save
    user
    binding.pry
    user
  end

  def delete_user_by_id(id)
    user = User.find id
    user.destroy
  end

  def get_all_users
    x = User.all.select(:full_name, :email, :phone_number, :id).map &:serializable_hash
    binding.pry
    x
  end

  def get_user_by_id(id)
    User.find_by_id id
  end

  def update_user_by_id(id, user_properties)
    user = User.find id
    user.update(user_properties)
  end
end

contract = Barrister::contract_from_file("./user_service.json")
server   = Barrister::Server.new(contract)
server.add_handler("UserService", UserService.new)

post '/user_service' do
  request.body.rewind
  resp = server.handle_json(request.body.read)

  status 200
  headers "Content-Type" => "application/json"
  resp
end
