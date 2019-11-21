class AddXeroItemCodeToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :xero_item_code, :string
  end
end
