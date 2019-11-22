FactoryBot.define do
  factory :trade_item do |f|
    f.sequence(:name) { |n| "Trade_Item_#{n}" }
    f.description { 'A trade Item' }
    f.sequence(:file_file_name) { |n| "item_#{n}.png" }
    f.file_content_type { 'image/png' }
    f.file_file_size { 15_718 }
  end
end
