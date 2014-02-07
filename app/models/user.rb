class User
  include ActiveAttr::Model

  attribute :full_name
  attribute :phone_number
  attribute :email
  attribute :id

  # for building a route
  def to_param
    "#{id}"
  end

  # for determining inflection
  def persisted?
    !id.nil?
  end
end
