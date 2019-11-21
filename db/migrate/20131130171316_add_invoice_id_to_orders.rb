class AddInvoiceIdToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :invoice_id, :string
  end
end
