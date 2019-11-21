module AdminHelper
  def logged_in?
    session[:user_id] != nil
  end

  def logged_in_as_admin?
    if logged_in?
      current_user = User.find_by_id(session[:user_id])
      current_user.admin
    else
      false
    end
  end

  def orders_link(orders, text = '', params = {})
    text = raw "#{pluralize orders.size, 'order'} #{text}"

    if orders.size == 1
      link_to(text, edit_admin_order_path(orders.first))
    else
      link_to(text, admin_orders_path(params))
    end
  end

  def contacts_link(contacts, text = '', params = {})
    text = raw "#{pluralize contacts.size, 'urgent contact'} #{text}"

    if contacts.size == 1
      link_to(text, edit_admin_contact_path(contacts.first))
    else
      link_to(text, admin_contacts_path(params))
    end
  end
end
