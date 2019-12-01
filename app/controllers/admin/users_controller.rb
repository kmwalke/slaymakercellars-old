# class Admin::UsersController < ApplicationController
class Admin::UsersController < ApplicationController
  before_action :logged_in_as_admin?
  def new
    @user = User.new
  end

  def index
    @show = params[:show]
    case @show
    when 'inactive'
      @users = User.where('deleted_at is not null')
      @title = 'Inactive Users'
    else
      @users = User.where('deleted_at is null').order(admin: :desc)
      @title = 'Active Users'
    end
  end

  def create
    @user = User.create(user_params)
    if @user.save
      @user.name = params[:user][:name]
      @user.save
      redirect_to admin_users_path, notice: 'Signed up!'
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update!(user_params)
        @user.save
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if User.count == 1
      notice = "Don't delete the last user"
    else
      @user = User.find(params[:id])

      @user.deleted_at = DateTime.now
      @user.save
      notice           = 'User archived'
    end

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: notice }
    end
  end

  def undestroy
    @user = User.find(params[:id])

    @user.deleted_at = nil
    @user.save
    notice           = 'User restored'

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: notice }
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :is_public,
      :photo,
      :description,
      :admin
    )
  end
end
