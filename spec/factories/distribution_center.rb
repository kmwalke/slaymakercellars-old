FactoryBot.define do
  factory :distribution_center do |f|
    f.sequence(:name) { |n| "DC_#{n}" }
    f.sequence(:phone) { |n| "Phone_#{n}" }
    f.sequence(:email) { |n| "Email_#{n}" }
    f.sequence(:contact_point) { |n| "Contact_Point_#{n}" }
  end
end
