class CreateLineItems < ActiveRecord::Migration[4.2]
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.text :size
      t.integer :units
      t.integer :order_id
    end
  end
end
