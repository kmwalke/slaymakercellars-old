class AddCustomerPoToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :customer_po, :string
  end
end
