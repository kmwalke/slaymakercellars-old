class CreateReports < ActiveRecord::Migration[4.2]
  def change
    create_table :reports do |t|
      t.string :report_type
      t.date :start_date
      t.date :end_date
      t.boolean :totals?
      t.date :last_run
      t.string :name
    end
  end
end
