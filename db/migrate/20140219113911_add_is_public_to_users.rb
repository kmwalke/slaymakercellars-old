class AddIsPublicToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_public, :boolean
    remove_column :users, :volunteer_coordinator
  end
end
