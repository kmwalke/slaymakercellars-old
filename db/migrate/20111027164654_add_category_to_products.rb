class AddCategoryToProducts < ActiveRecord::Migration[4.2]
  def change
    change_table :products do |t|
      t.string :category
    end
  end
end
