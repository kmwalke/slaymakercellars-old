class RemoveDcFromLineItem < ActiveRecord::Migration[4.2]
  def change
    remove_column :line_items, :distribution_center_id, :integer
  end
end
