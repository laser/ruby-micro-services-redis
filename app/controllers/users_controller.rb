class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @users = UserService.call('get_all_users')
  end

  def new
  end

  def create
    begin
      user = UserService.call('create_user', user_params)
      flash[:notice] = "Successfully created user with name #{user.full_name}"
    rescue Barrister::RpcException => e
      flash[:notice] = "Error creating user: #{e.message}"
    end

    redirect_to action: 'index'
  end

  def update
    begin
      user = UserService.call('update_user_by_id', params[:id].to_i, user_params)
      flash[:notice] = "Successfully edited user with name #{user.full_name}"
    rescue Barrister::RpcException => e
      flash[:notice] = "Error editing user: #{e.message}"
    end

    redirect_to action: 'edit'
  end

  def edit
    @user = UserService.call('get_user_by_id', params[:id].to_i)
  end

  def destroy
    user = UserService.call('get_user_by_id', params[:id].to_i)
    UserService.call('delete_user_by_id', user.id)
    flash[:notice] = "Successfully deleted user with name #{user.full_name}"

    redirect_to action: 'index'
  end

private
  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email)
  end
end
