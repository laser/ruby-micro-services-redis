class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @users = UserService.client.get_all_users.map { |user_hash| User.new(user_hash) }
  end

  def new
  end

  def create
    user = User.new(UserService.client.create_user(user_params))
    flash[:notice] = "Successfully created user with name #{user.full_name}"
    redirect_to action: 'index'
  end

  def update
    user = User.new(UserService.client.update_user_by_id(params[:id].to_i, user_params))
    flash[:notice] = "Successfully edited user with name #{user.full_name}"
    redirect_to action: 'edit'
  end

  def edit
    @user = User.new(UserService.client.get_user_by_id(params[:id].to_i))
  end

  def destroy
    user = User.new(UserService.client.get_user_by_id(params[:id].to_i))
    UserService.client.delete_user_by_id(user.id)
    flash[:notice] = "Successfully deleted user with name #{user.full_name}"
    redirect_to action: 'index'
  end

  def reset
    UserService.client.get_all_users.map do |user_hash|
      UserService.client.delete_user_by_id(user_hash["id"])
    end
    redirect_to action: 'index'
  end

private
  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email)
  end

end
