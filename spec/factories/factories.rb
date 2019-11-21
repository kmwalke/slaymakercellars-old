FactoryBot.define do
  factory :product do |f|
    f.sequence(:name) { |n| "Product_#{n}" }
    f.xero_item_code { 'FETA' }
    f.category { 'Year Round' }
    f.desc { 'This is a description' }
    f.in_production { true }
  end

  factory :article do |f|
    f.sequence(:title) { |n| "Article_#{n}" }
    f.body { 'This is a news story' }
    f.url { 'www.google.com' }
    f.date { Date.today }
  end

  factory :state do |f|
    f.name { 'Stateland' }
  end

  factory :town do |f|
    f.state
    f.name { 'Townville' }
  end

  factory :contact do |f|
    f.town
    f.distribution_center
    f.sequence(:business) { |n| "Business_#{n}" }
    f.sequence(:name) { |n| "Name_#{n}" }
    f.sequence(:email) { |n| "email_#{n}@hello.com" }
    f.price_point { 16.0 }
    f.status { 'Current' }
  end

  factory :note do |f|
    f.contact
    f.content { 'Issue' }
  end

  factory :order do |f|
    f.contact
    f.association :created_by, factory: :user
    f.delivery_date { Date.today }
    f.customer_po { 'PO 1234567890' }
  end

  factory :report do |f|
    f.report_type Report::REPORTTYPES.first
    f.start_date 1.month.ago
    f.end_date Date.today
    f.sequence(:name) { |n| "Report_#{n}" }
  end

  factory :user do |f|
    f.sequence(:name) { |n| "User_#{n}" }
    f.sequence(:email) { |n| "User_#{n}@kentwalkercheese.com" }
    f.password { 'secret' }
    f.description { 'This is a description' }
  end

  factory :trade_item do |f|
    f.sequence(:name) { |n| "Trade_Item_#{n}" }
    f.description { 'A trade Item' }
    f.sequence(:file_file_name) { |n| "item_#{n}.png" }
    f.file_content_type { 'image/png' }
    f.file_file_size { 15_718 }
  end

  factory :line_item do |f|
    f.order
    f.product
    f.size { LineItem.SIZES.last }
    f.units { 1.0 }
    f.fulfilled { false }
  end

  factory :distribution_center do |f|
    f.sequence(:name) { |n| "DC_#{n}" }
    f.sequence(:phone) { |n| "Phone_#{n}" }
    f.sequence(:email) { |n| "Email_#{n}" }
    f.sequence(:contact_point) { |n| "Contact_Point_#{n}" }
  end
end
