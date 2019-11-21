class AddUrlToAccounts < ActiveRecord::Migration[4.2]
  def change
    change_table :accounts do |t|
      t.string :url
    end
  end
end
