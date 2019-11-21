class AddStateToContact < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :state, :string
  end
end
