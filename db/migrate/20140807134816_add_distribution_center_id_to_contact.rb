class AddDistributionCenterIdToContact < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :distribution_center_id, :integer
  end
end
