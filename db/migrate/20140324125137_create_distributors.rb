class CreateDistributors < ActiveRecord::Migration[4.2]
  def change
    create_table :distributors do |t|
      t.string :name

      t.timestamps
    end
  end
end
