class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @users = UserService.call('get_all_users').result
  end

  def new
  end

  def create
    result = UserService.call('create_user', user_params)
    if result.error
      flash[:notice] = "Error creating user: #{result.error.message}"
    else
      user = result.result
      flash[:notice] = "Successfully created user with name #{user.full_name}"
    end
    redirect_to action: 'index'
  end

  def update
    result = UserService.call('update_user_by_id', params[:id].to_i, user_params)
    if result.error
      flash[:notice] = "Error editing user: #{result.error.message}"
    else
      user = result.result
      flash[:notice] = "Successfully edited user with name #{user.full_name}"
    end
    redirect_to action: 'edit'
  end

  def edit
    @user = UserService.call('get_user_by_id', params[:id].to_i).result
  end

  def destroy
    user   = UserService.call('get_user_by_id', params[:id].to_i).result
    result = UserService.call('delete_user_by_id', user.id)
    if result.error
      flash[:notice] = "Error deleting user: #{result.error.message}"
    else
      flash[:notice] = "Successfully deleted user with name #{user.full_name}"
    end
    redirect_to action: 'index'
  end

private
  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email)
  end
end
