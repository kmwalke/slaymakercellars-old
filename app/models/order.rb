class Order < ActiveRecord::Base
  belongs_to :contact
  has_many :line_items, dependent: :destroy, inverse_of: :order
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  accepts_nested_attributes_for :line_items,
                                reject_if: proc { |attributes| attributes['units'].blank? },
                                allow_destroy: true

  validates_presence_of :contact_id, :delivery_date

  scope :late, lambda do
    where('fullfilled_on is null and delivery_date < ?', Date.today).order('delivery_date asc')
  end

  scope :fulfilled, -> { where('fullfilled_on is not null').order('fullfilled_on DESC') }

  scope :active, -> { where(fullfilled_on: nil).order('delivery_date asc') }

  def self.display(show)
    case show
    when 'late'
      [Order.late, 'Late Orders']
    when 'fulfilled'
      [Order.fulfilled, 'Delivered Orders']
    when 'active'
      [Order.active, 'Active Orders']
    else
      contact = Contact.find_by_id(show)
      [contact.orders.order('delivery_date DESC'), "Orders by #{contact.business}"]
    end
  end

  def contact_business
    contact&.business
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
        LineItem::SIZES.each do |size|
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
