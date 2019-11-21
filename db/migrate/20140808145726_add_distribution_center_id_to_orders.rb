class AddDistributionCenterIdToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :distribution_center_id, :integer
  end
end
