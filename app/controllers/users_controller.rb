class UsersController < ApplicationController
  def index
    #@users = User.all
    raise 'NOT IMPLEMENTED'
  end

  def new
  end

  def create
    #user = User.new(user_params)
    #user.save
    #flash[:notice] = "Successfully created user with name #{user.full_name}"
    #redirect_to action: 'index'
    raise 'NOT IMPLEMENTED'
  end

  def update
    #user = User.find(params[:id])
    #user.update(user_params)
    #flash[:notice] = "Successfully edited user with name #{user.full_name}"
    #redirect_to action: 'edit'
    raise 'NOT IMPLEMENTED'
  end

  def edit
    #@user = User.find(params[:id])
    raise 'NOT IMPLEMENTED'
  end

  def destroy
    #user = User.find(params[:id])
    #user.destroy
    #flash[:notice] = "Successfully deleted user with name #{user.full_name}"
    #redirect_to action: 'index'
    raise 'NOT IMPLEMENTED'
  end

  def reset
    #User.destroy_all
    #redirect_to action: 'index'
    raise 'NOT IMPLEMENTED'
  end

private
  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email)
  end

end
