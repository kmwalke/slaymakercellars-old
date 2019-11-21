class AddShortListToVolunteers < ActiveRecord::Migration[4.2]
  def change
    add_column :volunteers, :on_short_list, :boolean
  end
end
