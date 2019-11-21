class ReportsMailer < ActionMailer::Base
  def sales_activity
    @email    = 'info@kentwalkercheese.com' # User.where(:admin => true).map{|u|u.email}
    @contacts = Contact.where(updated_at: 1.week.ago..Time.now).order('updated_at ASC')
    @orders   = Order.where(updated_at: 1.week.ago..Time.now).order('updated_at ASC')

    mail(
      to: @email,
      subject: 'Sales Activity this week',
      from: 'info@kentwalkercheese.com'
    )
  end
end
