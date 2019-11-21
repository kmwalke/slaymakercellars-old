class AddImagesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :photo_file_name, :string
    add_column :users, :photo_content_type, :string
    add_column :users, :photo_file_size, :integer
  end
end
