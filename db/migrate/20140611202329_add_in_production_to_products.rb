class AddInProductionToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :in_production, :boolean
  end
end
