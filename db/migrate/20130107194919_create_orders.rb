class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.integer :contact_id
      t.date :delivery_date
      t.date :fullfilled_on
      t.text :comments

      t.timestamps
    end
  end
end
