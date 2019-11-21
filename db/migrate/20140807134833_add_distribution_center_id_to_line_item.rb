class AddDistributionCenterIdToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_column :line_items, :distribution_center_id, :integer
  end
end
