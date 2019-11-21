class CreateNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :notes do |t|
      t.integer :contact_id
      t.integer :user_id
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
