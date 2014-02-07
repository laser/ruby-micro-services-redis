class User < ActiveRecord::Base
  validates_presence_of :full_name, :phone_number, :email
end
