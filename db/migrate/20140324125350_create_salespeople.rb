class CreateSalespeople < ActiveRecord::Migration[4.2]
  def change
    create_table :salespeople do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :distributor_id
      t.string :location

      t.timestamps
    end
  end
end
