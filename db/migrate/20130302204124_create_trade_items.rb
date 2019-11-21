class CreateTradeItems < ActiveRecord::Migration[4.2]
  def change
    create_table :trade_items do |t|
      t.string :name
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.boolean :is_public

      t.timestamps
    end
  end
end
