FactoryBot.define do
  factory :town do |f|
    f.state
    f.name { 'Townville' }
  end
end
