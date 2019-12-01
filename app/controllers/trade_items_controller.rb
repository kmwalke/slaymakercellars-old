class TradeItemsController < ApplicationController
  def index
    @trade_items = TradeItem.where(is_public: true)

    respond_to do |format|
      format.html
    end
  end
end
