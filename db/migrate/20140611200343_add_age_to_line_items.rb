class AddAgeToLineItems < ActiveRecord::Migration[4.2]
  def change
    add_column :line_items, :age, :text
  end
end
