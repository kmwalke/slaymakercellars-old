class AddTownIdToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :town_id, :integer

    remove_column :contacts, :town, :string
    remove_column :contacts, :state, :string
  end
end
