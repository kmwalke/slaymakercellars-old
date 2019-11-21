class AddCategoryToAccounts < ActiveRecord::Migration[4.2]
  def change
    change_table :accounts do |t|
      t.string :category
      t.string :type
    end
  end
end
