class AddAddressToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :address, :string
    add_column :contacts, :url, :string
    add_column :contacts, :is_public, :boolean
  end
end
