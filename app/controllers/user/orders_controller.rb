class User::OrdersController < ApplicationController
  before_action :logged_in?
  before_action :only_access_self

  def index
    if current_user.contact
      @orders, @title = Order.display(current_user.contact.orders, params[:show] || 'active')
    else
      @orders = nil
      @title  = 'Your account has not been set up'
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    @order = Order.find(params[:id])

    redirect_to edit_user_order_path(@order) unless @order.fulfilled_on
  end

  def new
    @order            = Order.new
    @contact_business = current_user.contact.business

    respond_to do |format|
      format.html
    end
  end

  def edit
    @order   = Order.find(params[:id])
    @invoice = xero.Invoice.find(@order.invoice_id) if @order.invoice_id
  end

  def create
    @order            = Order.create(order_params)
    @order.created_by = current_user
    @order.updated_by = current_user

    respond_to do |format|
      if @order.save
        OrderMailer.new_order(@order).deliver_now
        format.html do
          redirect_to edit_user_order_path(@order),
                      notice: 'Order was successfully created. <br /><br /> ' +
                              '<a href="/user/orders/new">Add Another Order</a>'.html_safe
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @order            = Order.find(params[:id])
    @order.updated_by = current_user
    xero_invoice      = nil

    xero_invoice                = xero.Invoice.first(where: { invoice_id: @order.invoice_id }) if xero
    params[:order][:invoice_id] = nil if xero_invoice.nil?

    respond_to do |format|
      if @order.update!(order_params)
        if params[:save]
          OrderMailer.updated_order(@order).deliver_now
          format.html { redirect_to user_orders_url }
        else
          format.html { redirect_to edit_user_order_path(@order), notice: 'Order was successfully updated.' }
        end
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to user_orders_url }
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :contact_business,
      :delivery_date,
      :distribution_center_id,
      :customer_po,
      :invoice_id,
      :comments,
      :created_by_id,
      :updated_by_id,
      line_items_attributes: [:fulfilled, :units, :size, :age, :product_id, :id, :_destroy]
    )
  end

  def only_access_self
    return unless params[:id]

    order = Order.find_by_id(params[:id])
    if order.contact
      redirect_to user_orders_path unless order.contact.user == current_user
    else
      redirect_to user_orders_path
    end
  end
end
