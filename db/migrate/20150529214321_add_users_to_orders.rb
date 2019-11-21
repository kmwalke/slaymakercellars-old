class AddUsersToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :created_by_id, :integer
    add_column :orders, :updated_by_id, :integer

    Order.update_all(created_by_id: 1)
  end
end
