class Admin::TradeItemsController < ApplicationController
  before_action :logged_in_as_admin?
  # GET /trade_items
  # GET /trade_items.json
  def index
    @trade_items = TradeItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trade_items }
    end
  end

  # GET /trade_items/1
  # GET /trade_items/1.json
  def show
    @trade_item = TradeItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trade_item }
    end
  end

  # GET /trade_items/new
  # GET /trade_items/new.json
  def new
    @trade_item = TradeItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trade_item }
    end
  end

  # GET /trade_items/1/edit
  def edit
    @trade_item = TradeItem.find(params[:id])
  end

  # POST /trade_items
  # POST /trade_items.json
  def create
    @trade_item = TradeItem.create(trade_item_params)

    respond_to do |format|
      if @trade_item.save
        format.html { redirect_to admin_trade_items_path, notice: 'Trade item was successfully created.' }
        format.json { render json: @trade_item, status: :created, location: @trade_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @trade_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trade_items/1
  # PUT /trade_items/1.json
  def update
    @trade_item = TradeItem.find(params[:id])

    respond_to do |format|
      if @trade_item.update!(trade_item_params)
        format.html { redirect_to admin_trade_items_path, notice: 'Trade item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trade_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trade_items/1
  # DELETE /trade_items/1.json
  def destroy
    @trade_item = TradeItem.find(params[:id])
    @trade_item.destroy

    respond_to do |format|
      format.html { redirect_to admin_trade_items_path }
      format.json { head :ok }
    end
  end

  private

  def trade_item_params
    params.require(:trade_item).permit(:name, :file_file_name, :file_content_type, :file_file_size, :is_public, :description)
  end
end
