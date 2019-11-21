class TradeItemsController < ApplicationController
  # GET /trade_items
  # GET /trade_items.json
  def index
    @trade_items = TradeItem.where(is_public: true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trade_items }
    end
  end
end
