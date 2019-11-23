FactoryBot.define do
  factory :line_item do |f|
    f.order
    f.product
    f.size { LineItem::SIZES.last }
    f.units { 1.0 }
    f.fulfilled { false }
  end
end
