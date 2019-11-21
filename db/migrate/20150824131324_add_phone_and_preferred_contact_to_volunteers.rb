class AddPhoneAndPreferredContactToVolunteers < ActiveRecord::Migration[4.2]
  def change
    add_column :volunteers, :phone, :string
    add_column :volunteers, :preferred_contact, :string
  end
end
