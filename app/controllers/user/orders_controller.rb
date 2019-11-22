class User::OrdersController < ApplicationController
  before_action :logged_in?
  before_action :only_access_self

  def xero_invoice_link
    'https://go.xero.com/AccountsReceivable/Edit.aspx?InvoiceID='
  end

  # GET /orders
  # GET /orders.json
  def index
    if current_user.contact
      @show = params[:show] || 'active'
      case @show
      when 'late'
        @orders = current_user.contact.orders.where(
          'fullfilled_on is null and delivery_date < ?', Date.today
        ).order('fullfilled_on DESC')
        @title  = 'Late Orders'
      when 'fulfilled'
        @orders = current_user.contact.orders.where('fullfilled_on is not null').order('fullfilled_on DESC')
        @title  = 'Fulfilled Orders'
      when 'active'
        @orders = current_user.contact.orders.where(fullfilled_on: nil).order('delivery_date ASC')
        @title  = 'Active Orders'
      else
        @orders = current_user.contact.orders.order('delivery_date DESC')
        @title  = 'All Orders'
      end
    else
      @orders = nil
      @title  = 'Your account has not been set up'
    end

    #    @orders = @orders.paginate(:per_page => 20, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    redirect_to edit_user_order_path(@order) unless @order.fullfilled_on
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order            = Order.new
    @contact_business = current_user.contact.business

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order     = Order.find(params[:id])
    @order_ids = Order.where(fullfilled_on: nil).order('delivery_date ASC').map(&:id)
    prev_index = @order_ids.find_index(@order.id) - 1
    next_index = @order_ids.find_index(@order.id) + 1

    next_index = 0 if next_index >= @order_ids.count

    @prev_id           = @order_ids[prev_index]
    @next_id           = @order_ids[next_index]
    @xero_invoice_link = xero_invoice_link
    @invoice           = xero.Invoice.find(@order.invoice_id) if @order.invoice_id
  end

  # POST /orders
  # POST /orders.json
  def create
    @order            = Order.create(order_params)
    @order.created_by = current_user

    respond_to do |format|
      if @order.save
        OrderMailer.new_order(@order).deliver_now
        format.html do
          redirect_to edit_user_order_path(@order),
                      notice: 'Order was successfully created. <br /><br /> ' +
                              '<a href="/user/orders/new">Add Another Order</a>'.html_safe
        end
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
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
          format.json { head :ok }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to user_orders_url }
      format.json { head :ok }
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
