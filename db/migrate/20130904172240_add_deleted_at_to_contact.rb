class AddDeletedAtToContact < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :deleted_at, :datetime
  end
end
