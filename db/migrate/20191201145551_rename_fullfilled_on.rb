class RenameFullfilledOn < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :fullfilled_on, :fulfilled_on
  end
end
