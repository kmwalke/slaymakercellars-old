class AddPublicToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :is_public, :boolean
  end
end
