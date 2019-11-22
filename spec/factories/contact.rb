FactoryBot.define do
  factory :contact do |f|
    f.town
    f.distribution_center
    f.sequence(:business) { |n| "Business_#{n}" }
    f.sequence(:name) { |n| "Name_#{n}" }
    f.sequence(:email) { |n| "email_#{n}@hello.com" }
    f.price_point { 16.0 }
    f.status { 'Current' }
  end
end
