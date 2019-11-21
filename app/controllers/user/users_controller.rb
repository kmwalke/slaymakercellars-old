class User::UsersController < ApplicationController
  before_action :logged_in?

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)

    respond_to do |format|
      if @user.update!(user_params)
        @user.save
        format.html { redirect_to edit_user_user_path(current_user.id), notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
