class CreateDistributionCenters < ActiveRecord::Migration[4.2]
  def change
    create_table :distribution_centers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :contact_point

      t.timestamps
    end
  end
end
