class Admin::FulfillmentController < ApplicationController
  before_action :logged_in_as_admin?

  def index
    @fulfillment = GetOrderFulfillment.call
  end
end
