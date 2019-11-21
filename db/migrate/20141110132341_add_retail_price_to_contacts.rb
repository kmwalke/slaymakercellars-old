class AddRetailPriceToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :mark_retail, :boolean
    add_column :contacts, :price_per_ounce, :float
  end
end
