class RemoveAgeFromLineItems < ActiveRecord::Migration[4.2]
  def change
    remove_column :line_items, :age
  end
end
