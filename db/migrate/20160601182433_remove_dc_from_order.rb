class RemoveDcFromOrder < ActiveRecord::Migration[4.2]
  def change
    remove_column :orders, :distribution_center_id, :integer
  end
end
