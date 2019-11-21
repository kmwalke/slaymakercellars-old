class AddDescriptionToTradeItems < ActiveRecord::Migration[4.2]
  def change
    add_column :trade_items, :description, :text
  end
end
