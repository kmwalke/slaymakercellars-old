FactoryBot.define do
  factory :product do |f|
    f.sequence(:name) { |n| "Product_#{n}" }
    f.xero_item_code { 'FETA' }
    f.category { 'Year Round' }
    f.desc { 'This is a description' }
    f.in_production { true }
  end
end
