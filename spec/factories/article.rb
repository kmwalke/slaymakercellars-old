FactoryBot.define do
  factory :article do |f|
    f.sequence(:title) { |n| "Article_#{n}" }
    f.body { 'This is a news story' }
    f.url { 'www.google.com' }
    f.date { Date.today }
  end
end
