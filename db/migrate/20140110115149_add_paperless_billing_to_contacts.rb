class AddPaperlessBillingToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :paperless_billing, :boolean
  end
end
