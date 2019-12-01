class XeroCreateInvoice
  ACCOUNT  = 'ACCREC'.freeze
  DUE_DAYS = 30

  def self.call(contact, customer_po)
    new(contact, customer_po).call
  end

  def initialize(contact, customer_po)
    @contact     = contact
    @customer_po = customer_po
  end

  def call
    xero.Invoice.build(
      type: ACCOUNT,
      date: Date.today,
      due_date: Date.today + DUE_DAYS,
      contact: contact,
      reference: customer_po
    )
  end
end
