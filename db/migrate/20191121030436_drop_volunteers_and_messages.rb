class DropVolunteersAndMessages < ActiveRecord::Migration[6.0]
  def up
    drop_table :volunteers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
