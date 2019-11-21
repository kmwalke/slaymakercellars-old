class ApplicationController < ActionController::Base
  protect_from_forgery

  # Set this to true to test Xero integration in the dev environment
  # Don't forget to change it in spec_helper, too
  def testing_xero
    false
  end

  def xero
    @xero ||= if Rails.env.production? || testing_xero
                Xeroizer::PrivateApplication.new(
                  'KPTXBBJT7MY3WHJTGMJFHDX1HBPEEP',
                  '4K7UZDW2WUR1DG6PRSPE88ND0JO8WP',
                  "#{Rails.root}/xero/privatekey.pem"
                )
              else
                Xeroizer::PrivateApplication.new(
                  'OKSGYSBMFCIPQVK6DPPCD8PRIWSIQ0',
                  'IQFZ9B1N5WJYMB5CHHAU8ADN6NUA1V',
                  "#{Rails.root}/xero/privatekey.pem"
                )
              end
  end

  def logged_in?
    return if current_user&.active?

    flash[:notice]             = 'You must log in to see this page.'
    session[:orig_destination] = request.path
    redirect_to login_path
  end

  def logged_in_as_admin?
    if current_user
      unless current_user.admin && current_user.active?
        flash[:notice]             = 'You must be an admin to see this page.'
        session[:orig_destination] = request.path
        redirect_to user_orders_path
      end
    else
      logged_in?
    end
  end

  def humanize_time(time)
    time.strftime('%I:%M %p')
  end

  def humanize_date(date)
    date.strftime('%A, %B %d, %Y')
  end

  def humanize_date_time(date_time)
    date_time.strftime('%A, %B %d, %Y - %I:%M %p')
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
