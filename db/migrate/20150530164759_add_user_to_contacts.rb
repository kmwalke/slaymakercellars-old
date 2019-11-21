class AddUserToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :user_id, :integer
  end
end
