class AddTaxIdNumberToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :tax_id_number, :string
  end
end
