class Order < ActiveRecord::Base
  belongs_to :contact
  has_many :line_items, dependent: :destroy, inverse_of: :order
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  accepts_nested_attributes_for :line_items,
                                reject_if: proc { |attributes| attributes['units'].blank? },
                                allow_destroy: true

  validates_presence_of :contact_id, :delivery_date

  scope :late, lambda {
    where('fulfilled_on is null and delivery_date < ?', Date.today).order('delivery_date asc')
  }

  scope :fulfilled, -> { where('fulfilled_on is not null').order('fulfilled_on DESC') }

  scope :active, -> { where(fulfilled_on: nil).order('delivery_date asc') }

  def self.to_be_fulfilled(day)
    if day == Date.today
      Order.where('fulfilled_on is NULL AND delivery_date <= ?', Date.today)
    else
      Order.where(fulfilled_on: nil, delivery_date: day)
    end
  end

  def self.display_all(show)
    display(Order.all, show)
  end

  def self.display(orders, show)
    case show
    when 'late'
      [orders.late, 'Late Orders']
    when 'fulfilled'
      [orders.fulfilled, 'Delivered Orders']
    when 'active'
      [orders.active, 'Active Orders']
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
    fulfilled_on != nil
  end

  def fulfill
    self.fulfilled_on = Date.today
  end

  def unfulfill
    self.fulfilled_on = nil
  end
end
