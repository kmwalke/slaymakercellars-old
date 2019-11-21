class CreateTowns < ActiveRecord::Migration[4.2]
  def change
    create_table :towns do |t|
      t.string :name
      t.integer :state_id

      t.timestamps null: false
    end
  end
end
