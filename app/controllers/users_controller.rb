class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @users = Services.user_service.get_all_users
  end

  def new
  end

  def create
    begin
      user = Services.user_service.create_user user_params
      flash[:notice] = "Successfully created user with name #{user.full_name}"
    rescue Barrister::RpcException => e
      flash[:notice] = "Error creating user: #{e.message}"
    end

    redirect_to action: 'index'
  end

  def update
    begin
      user = Services.user_service.update_user_by_id params[:id].to_i, user_params
      flash[:notice] = "Successfully edited user with name #{user.full_name}"
    rescue Barrister::RpcException => e
      flash[:notice] = "Error editing user: #{e.message}"
    end

    redirect_to action: 'edit'
  end

  def edit
    @user = Services.user_service.get_user_by_id params[:id].to_i
  end

  def destroy
    user = Services.user_service.get_user_by_id params[:id].to_i
    Services.user_service.delete_user_by_id user.id
    flash[:notice] = "Successfully deleted user with name #{user.full_name}"

    redirect_to action: 'index'
  end

private
  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email)
  end
end
