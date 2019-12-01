class Admin::TradeItemsController < ApplicationController
  before_action :logged_in_as_admin?
  def index
    @trade_items = TradeItem.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @trade_item = TradeItem.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @trade_item = TradeItem.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @trade_item = TradeItem.find(params[:id])
  end

  def create
    @trade_item = TradeItem.create(trade_item_params)

    respond_to do |format|
      if @trade_item.save
        format.html { redirect_to admin_trade_items_path, notice: 'Trade item was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @trade_item = TradeItem.find(params[:id])

    respond_to do |format|
      if @trade_item.update!(trade_item_params)
        format.html { redirect_to admin_trade_items_path, notice: 'Trade item was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @trade_item = TradeItem.find(params[:id])
    @trade_item.destroy

    respond_to do |format|
      format.html { redirect_to admin_trade_items_path }
    end
  end

  private

  def trade_item_params
    params.require(:trade_item).permit(
      :name,
      :file_file_name,
      :file_content_type,
      :file_file_size,
      :is_public,
      :description
    )
  end
end
