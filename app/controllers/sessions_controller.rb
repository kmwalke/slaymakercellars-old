class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password]) && user&.active?
      session[:user_id] = user.id
      xero
      if user.admin
        if session[:orig_destination]
          orig                       = session[:orig_destination]
          session[:orig_destination] = nil
          redirect_to orig, notice: 'Logged in!'
        else
          redirect_to admin_url, notice: 'Logged in!'
        end
      else
        redirect_to user_orders_url, notice: 'Logged in!'
      end
    else
      redirect_to login_path, notice: 'Invalid email or password'
    end
  end

  def destroy
    session[:user_id] = nil
    xero              = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
