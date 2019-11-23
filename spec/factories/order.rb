FactoryBot.define do
  factory :order do |f|
    f.contact
    f.association :created_by, factory: :user
    f.association :updated_by, factory: :user
    f.delivery_date { Date.today }
    f.customer_po { 'PO 1234567890' }
  end
end
