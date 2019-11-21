class ChangeAddressToText < ActiveRecord::Migration[4.2]
  def up
    change_table :contacts do |t|
      t.change :address, :text
    end
  end

  def down
    change_table :contacts do |t|
      t.change :address, :string
    end
  end
end
