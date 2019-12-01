class AdminController < ApplicationController
  before_action :logged_in_as_admin?

  def index
    @late_orders          = Order.where('delivery_date < ? and fulfilled_on is NULL', Date.today)
    @orders               = Order.where(fulfilled_on: nil)
    @todays_orders        = Order.where(fulfilled_on: nil, delivery_date: Date.today)
    @contacts             = Contact.count
    @urgent_contacts      = Contact.urgent_contacts
    @articles             = Article.count
    @distribution_centers = DistributionCenter.count
    @products             = Product.count
    @active_products      = Product.where(in_production: true).count
    @states               = State.count
    @towns                = Town.count
  end
end
