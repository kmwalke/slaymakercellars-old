class Admin::OrdersController < ApplicationController
  before_action :logged_in_as_admin?

  def index
    @invoices       = xero.Invoice.all if Rails.env.production? || testing_xero
    @orders, @title = Order.display(params[:show] || 'active')

    respond_to do |format|
      format.html
    end
  end

  def invoice
    # @order        = Order.find(params[:id])
    # rails_contact = @order.contact
    # if Rails.env.production? || testing_xero
    # xero_contact = XeroFindOrCreateContact.new(rails_contact.business)
    #
    # invoice = XeroCreateInvoice.new(xero_contact, @order.customer_po)
    #
    # if @order.line_items.empty?
    #   flash[:notice] = 'Please create some Line Items.  Your invoice was NOT saved.'
    #   redirect_to admin_order_path(@order)
    #   return
    # end
    #
    # @order.line_items.each do |line_item|
    #   if line_item.product.nil?
    #     flash[:notice] = 'Please select a cheese in your Line Items.  Your invoice was NOT saved.'
    #     redirect_to admin_order_path(@order)
    #   end
    #   invoice.add_line_item(
    #     item_code: line_item.product.xero_item_code,
    #     description: line_item.units.to_s + 'x ' + line_item.size + ' ' + line_item.product.name,
    #     quantity: 1,
    #     account_code: LineItem::ACCOUNT_CODES[line_item.size],
    #     unit_amount: rails_contact.price_point
    #   )
    # end
    #
    # if invoice.save
    #   flash[:notice]    = 'A new invoice was created in Xero'
    #   @order.invoice_id = invoice.invoice_id
    #   @order.save
    # else
    #   flash[:notice] = "#{invoice.inspect}An error occurred.  Your invoice was NOT saved."
    # end
    # end

    flash[:notice] = 'Xero integration disabled. Your invoice was NOT saved.'
    redirect_to admin_order_path(@order)
  end

  def fulfill
    @order = Order.find(params[:id])
    @order.fulfill

    respond_to do |format|
      if @order.save
        format.html do
          redirect_to admin_orders_path,
                      notice: 'Order was successfully delivered. <br /><br />' +
                              "<a href=\"/admin/orders/#{@order.id}\">View Order</a>".html_safe
        end
      else
        format.html { redirect_to admin_orders_path, notice: 'Error' }
      end
    end
  end

  def unfulfill
    @order = Order.find(params[:id])
    @order.unfulfill

    respond_to do |format|
      if @order.save
        format.html { redirect_to edit_admin_order_path(@order), notice: 'Order was successfully undelivered.' }
      else
        format.html { redirect_to admin_order_path(@order), notice: 'Error' }
      end
    end
  end

  def show
    @order   = Order.find(params[:id])
    @invoice = xero.Invoice.find(@order.invoice_id) if @order.invoice_id

    redirect_to(edit_admin_order_path(@order.id)) if @order.fulfilled_on.nil? && @order.invoice_id.nil?
  end

  def new
    @order            = Order.new
    @contact_business = params[:contact]

    respond_to do |format|
      format.html
    end
  end

  def edit
    @order   = Order.find(params[:id])
    @invoice = xero.Invoice.find(@order.invoice_id) if @order.invoice_id

    redirect_to(admin_order_path(@order.id)) if @order.fulfilled_on || @order.invoice_id
  end

  def create
    @order            = Order.create(order_params)
    @order.created_by = current_user
    @order.updated_by = current_user

    respond_to do |format|
      if @order.save
        OrderMailer.new_order(@order).deliver_now
        format.html do
          redirect_to edit_admin_order_path(@order),
                      notice: 'Order was successfully created. <br /><br />' +
                              ' <a href="/admin/orders/new">Add Another Order</a>'.html_safe
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
    # xero_invoice      = xero.Invoice.first(where: { invoice_id: @order.invoice_id }) if xero
    path              = params[:save] ? admin_orders_url : edit_admin_order_url(@order)

    params[:order][:invoice_id] = nil if xero_invoice.nil?
    respond_to do |format|
      if @order.update!(order_params)
        OrderMailer.updated_order(@order).deliver_now
        format.html { redirect_to path, notice: 'Order was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to admin_orders_url }
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :contact_business, :delivery_date, :distribution_center_id, :customer_po, :invoice_id, :comments, :created_by_id,
      :updated_by_id, line_items_attributes: [:fulfilled, :units, :size, :product_id, :id, :_destroy]
    )
  end
end
