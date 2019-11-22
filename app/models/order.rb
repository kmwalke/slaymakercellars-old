class Order < ActiveRecord::Base
  belongs_to :contact
  belongs_to :distribution_center
  has_many :line_items, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  accepts_nested_attributes_for :line_items,
                                reject_if: proc { |attributes| attributes['units'].blank? },
                                allow_destroy: true

  validates_presence_of :contact_id, :delivery_date

  def contact_business
    contact.try(:business)
  end

  def contact_business=(business)
    self.contact = Contact.find_by_business(business) if business.present?
  end

  def fulfilled?
    fullfilled_on != nil
  end

  def fulfill
    self.fullfilled_on = Date.today
  end

  def unfulfill
    self.fullfilled_on = nil
  end

  def self.fulfillment
    result = {}
    week   = Date.today...Date.today + 7
    today  = true

    week.each do |day|
      result[day] = {}
      orders      = if today
                      Order.where('fullfilled_on is NULL AND delivery_date <= ?', Date.today)
                    else
                      Order.where(fullfilled_on: nil, delivery_date: day)
                    end
      today       = false

      Product.where(in_production: true).each do |product|
        result[day][product.name] = {}
        LineItem.SIZES.each do |size|
          total = 0

          orders.each do |order|
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
