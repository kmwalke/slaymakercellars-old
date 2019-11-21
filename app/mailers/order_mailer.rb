class OrderMailer < ActionMailer::Base
  def new_order(order)
    @email    = User.where(admin: true).map(&:email)
    @business = order.contact.business
    @order    = order

    mail(
      to: @email,
      subject: 'New Order for ' + @business,
      from: 'info@kentwalkercheese.com'
    )
  end

  def updated_order(order)
    @email    = User.where(admin: true).map(&:email)
    @business = order.contact.business
    @order    = order

    mail(
      to: @email,
      subject: 'Updated Order for ' + @business,
      from: 'info@kentwalkercheese.com'
    )
  end
end
