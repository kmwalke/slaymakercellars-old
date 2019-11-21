class CreateVolunteers < ActiveRecord::Migration[4.2]
  def change
    create_table :volunteers do |t|
      t.string 'name'
      t.string 'email'
      t.boolean 'active'

      t.timestamps
    end
  end
end
