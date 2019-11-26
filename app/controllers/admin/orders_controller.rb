class Admin::OrdersController < ApplicationController
  before_action :logged_in_as_admin?

  def xero_invoice_link
    'https://go.xero.com/AccountsReceivable/Edit.aspx?InvoiceID='
  end

  def index
    @show = params[:show] || 'active'
    if Rails.env.production? || testing_xero
      @invoices          = xero.Invoice.all
      @xero_invoice_link = xero_invoice_link
    end
    case @show
    when 'late'
      @orders = Order.where('fullfilled_on is null and delivery_date < ?', Date.today).order('fullfilled_on DESC')
      @title  = 'Late Orders'
    when 'fulfilled'
      @orders = Order.where('fullfilled_on is not null').order('fullfilled_on DESC')
      @title  = 'Delivered Orders'
    when 'active'
      @orders = Order.where(fullfilled_on: nil).order('delivery_date ASC')
      @title  = 'Active Orders'
    else
      contact = Contact.find_by_id(@show)
      @orders = contact.orders.order('delivery_date DESC')
      @title  = "Orders by #{contact.business}"
    end

    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end

  def invoice
    @order        = Order.find(params[:id])
    rails_contact = @order.contact
    if Rails.env.production? || testing_xero
      xero_contact = xero.Contact.first(where: { name: rails_contact.business })

      xero_contact = xero.Contact.build(name: rails_contact.business) if xero_contact.nil?

      invoice = xero.Invoice.build(
        type: 'ACCREC',
        date: Date.today,
        due_date: Date.today + 30,
        contact: xero_contact,
        reference: @order.customer_po
      )

      if @order.line_items.empty?
        flash[:notice] = 'Please create some Line Items.  Your invoice was NOT saved.'
        redirect_to admin_order_path(@order)
        return
      else
        @order.line_items.each do |line_item|
          if line_item.product.nil?
            flash[:notice] = 'Please select a cheese in your Line Items.  Your invoice was NOT saved.'
            redirect_to admin_order_path(@order)
          end
          invoice.add_line_item(
            item_code: line_item.product.xero_item_code,
            description: line_item.units.to_s + 'x ' + line_item.size + ' ' + line_item.product.name,
            quantity: 1,
            account_code: LineItem::ACCOUNT_CODES[line_item.size],
            unit_amount: rails_contact.price_point
          )
        end
      end

      saved = invoice.save

      if saved
        flash[:notice]    = 'A new invoice was created in Xero'
        @order.invoice_id = invoice.invoice_id
        @order.save
      else
        flash[:notice] = "#{invoice.inspect}An error occurred.  Your invoice was NOT saved."
      end
    end

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
    @order             = Order.find(params[:id])
    @xero_invoice_link = xero_invoice_link
    @invoice           = xero.Invoice.find(@order.invoice_id) if @order.invoice_id

    redirect_to(edit_admin_order_path(@order.id)) && return if @order.fullfilled_on.nil? && @order.invoice_id.nil?
  end

  def new
    @order            = Order.new
    @contact_business = params[:contact]

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find(params[:id])

    redirect_to(admin_order_path(@order.id)) && return if @order.fullfilled_on || @order.invoice_id

    @order_ids = Order.where(fullfilled_on: nil).order('delivery_date ASC').map(&:id)
    prev_index = @order_ids.find_index(@order.id) - 1
    next_index = @order_ids.find_index(@order.id) + 1

    next_index = 0 if next_index >= @order_ids.count

    @prev_id           = @order_ids[prev_index]
    @next_id           = @order_ids[next_index]
    @xero_invoice_link = xero_invoice_link
    @invoice           = xero.Invoice.find(@order.invoice_id) if @order.invoice_id
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
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
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
          format.html { redirect_to admin_orders_url }
        else
          format.html { redirect_to edit_admin_order_path(@order), notice: 'Order was successfully updated.' }
          format.json { head :ok }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to admin_orders_url }
      format.json { head :ok }
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
