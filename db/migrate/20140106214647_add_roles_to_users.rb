class AddRolesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :volunteer_coordinator, :boolean
  end
end
