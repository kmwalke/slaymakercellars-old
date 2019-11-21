class AddPhoneToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :phone, :string
    add_column :contacts, :email, :string
  end
end
