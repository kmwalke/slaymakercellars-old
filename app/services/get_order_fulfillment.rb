class GetOrderFulfillment
  def self.call
    result = {}
    week   = Date.today...Date.today + 7

    week.each do |day|
      result[day] = {}

      Product.where(in_production: true).each do |product|
        result[day][product.name] = {}
        LineItem::SIZES.each do |size|
          total = 0

          Order.to_be_fulfilled(day).each do |order|
            li                  = order.line_items.where(size: size, product_id: product.id, fulfilled: false)
            li.map { |l| total += l.units }
          end
          result[day][product.name][size] = total
        end
      end
    end

    result
  end
end
