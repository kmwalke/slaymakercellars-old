class AddUpdatedByIdToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :updated_by_id, :integer
  end
end
