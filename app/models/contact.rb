class Contact < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :notes # , :order => 'created_at desc'
  belongs_to :town
  belongs_to :user, optional: true
  belongs_to :distribution_center
  belongs_to :updated_by, class_name: 'User'
  accepts_nested_attributes_for :orders, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :business, :price_point
  validate :retail_price

  def retail_price
    return unless mark_retail && price_per_ounce.nil?

    errors.add(:price_per_ounce, "must be a dollar value if 'Mark Retail Price' is checked")
  end

  STATUSES = %w[Current Target Misc.].freeze

  scope :target_contacts, -> { where("status='Target' and deleted_at is null").order 'business ASC' }

  scope :misc_contacts, -> { where("status='Misc.' and deleted_at is null").order 'business ASC' }

  scope :current_contacts, -> { where("status='Current' and deleted_at is null").order 'business ASC' }

  scope :urgent_contacts, -> { where(id: Note.where(deleted_at: nil).uniq.pluck(:contact_id)) }

  def self.display(show, search_string)
    case show
    when 'target'
      contacts = Contact.target_contacts
      title    = 'Target Contacts'
    when 'misc'
      contacts = Contact.misc_contacts
      title    = 'Misc. Contacts'
    when 'urgent'
      contacts = Contact.urgent_contacts
      title    = 'Urgent Contacts'
    when 'inactive'
      contacts = Contact.where('deleted_at is not null').search(search_string)
      title    = 'Deleted Contacts'
    else
      show     = 'active'
      contacts = Contact.current_contacts.search(search_string)
      title    = 'Active Contacts'
    end

    [show, contacts, title]
  end

  def self.search(search)
    if search
      where('lower(name) LIKE lower(?) OR lower(business) LIKE lower(?)', "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  def unresolved_notes?
    !notes.where('deleted_at is null').empty?
  end

  def last_order
    order = orders.order('fulfilled_on desc').first

    order.fulfilled_on || Date.today if order
  end

  def repeat_last_order
    if orders.empty?
      new_order               = Order.new
      new_order.contact_id    = id
      new_order.delivery_date = Date.today
      new_order.save
    else
      order                   = orders.order('fulfilled_on desc').first
      new_order               = order.dup
      new_order.invoice_id    = nil
      new_order.fulfilled_on  = nil
      new_order.delivery_date = Date.today
      new_order.save
      order.line_items.each do |item|
        new_order.line_items.create(item.dup.attributes)
      end

    end
    new_order
  end
end
