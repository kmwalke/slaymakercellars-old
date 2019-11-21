class CreateContacts < ActiveRecord::Migration[4.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :business
      t.string :title
      t.string :town
      t.text :comments
      t.float :price_point

      t.timestamps
    end
  end
end
