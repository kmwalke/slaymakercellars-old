FactoryBot.define do
  factory :user do |f|
    f.sequence(:name) { |n| "User_#{n}" }
    f.sequence(:email) { |n| "User_#{n}@kentwalkercheese.com" }
    f.password { 'secret' }
    f.description { 'This is a description' }
  end
end
