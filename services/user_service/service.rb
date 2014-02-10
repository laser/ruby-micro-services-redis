class UserService
  USER_PROPERTIES = %w(id full_name email phone_number)

  def get_all_users()
    User.all.map &method(:to_serializable)
  end

  def get_user_by_id(id)
    to_serializable User.find(id)
  end

  def delete_user_by_id(id)
    !!User.destroy(id)
  end

  def update_user_by_id(id, user_properties)
    to_serializable(User.update(id, user_properties))
  end

  def create_user(user_properties)
    to_serializable(User.create(user_properties))
  end

private
  def to_serializable(user_model)
    user_model.serializable_hash.slice *USER_PROPERTIES
  end
end
