class ChangeLineItemUnitsToFloat < ActiveRecord::Migration[4.2]
  def up
    change_table :line_items do |t|
      t.change :units, :float
    end
  end

  def down
    change_table :line_items do |t|
      t.change :units, :integer
    end
  end
end
