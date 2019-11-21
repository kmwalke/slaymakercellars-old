class CreateProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :desc
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.integer :position
    end
  end
end
