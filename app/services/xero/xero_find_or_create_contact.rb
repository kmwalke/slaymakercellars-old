class XeroFindOrCreateContact
  def self.call(name)
    new(name).call
  end

  def initialize(name)
    @name = name
  end

  def call
    xero.Contact.first(where: { name: @name }) || xero.Contact.build(name: @name)
  end
end
