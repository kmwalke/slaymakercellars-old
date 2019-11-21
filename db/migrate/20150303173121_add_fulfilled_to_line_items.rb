class AddFulfilledToLineItems < ActiveRecord::Migration[4.2]
  def change
    add_column :line_items, :fulfilled, :boolean
  end
end
