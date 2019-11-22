FactoryBot.define do
  factory :note do |f|
    f.contact
    f.content { 'Issue' }
  end
end
