require 'spec_helper'

describe 'Admin::Orders' do
  it 'opens Admin::Orders' do
    login_as_admin
    visit admin_orders_path

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content('Orders')
  end

  it 'creates an order' do
    login_as_admin
    order = FactoryBot.create(:order)
    visit admin_orders_path

    first(:link, 'New Order').click
    expect(current_path).to eq(new_admin_order_path)

    fill_in 'Contact business', with: order.contact.business
    fill_in 'Delivery date', with: order.delivery_date

    click_button 'Save'
    expect(current_path).to eq(edit_admin_order_path(order.id + 1))
    expect(page).to have_content('created')
  end

  it 'updates an order' do
    login_as_admin
    order    = FactoryBot.create(:order)
    order_id = order.id
    new_date = order.delivery_date + 1
    visit admin_orders_path

    click_link order.contact.business
    expect(current_path).to eq(edit_admin_order_path(order_id))

    fill_in 'Delivery date', with: new_date

    first(:button, 'Update').click
    expect(current_path).to eq(edit_admin_order_path(order_id))
    expect(Order.find_by_id(order_id).delivery_date).to eq(new_date)

    fill_in 'Delivery date', with: new_date + 1
    first(:button, 'Save & Finish').click
    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id).delivery_date).to eq(new_date + 1)
  end

  it 'records users creating orders' do
    user  = login_as_admin
    order = FactoryBot.create(:order, created_by: user)
    visit edit_admin_order_path(order.id)

    expect(page).to have_content('Created by')
    expect(page).to have_content(user.name)
  end

  it 'records users updating orders' do
    user  = login_as_admin
    order = FactoryBot.create(:order, created_by: user)

    visit edit_admin_order_path(order.id)
    new_date = order.delivery_date + 1
    fill_in 'Delivery date', with: new_date

    first(:button, 'Update').click

    visit edit_admin_order_path(order.id)
    expect(page).to have_content('Updated by')
    expect(page).to have_content(user.name)
  end

  it 'deletes an order from index' do
    login_as_admin
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link "void_#{order.id}"

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id)).to eq(nil)
  end

  it 'deletes an order from order page' do
    login_as_admin
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link order.contact.business
    click_link 'Void'

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id)).to eq(nil)
  end

  it 'delivers an order from index' do
    login_as_admin
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link "deliver_#{order.id}"

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id).fullfilled_on).not_to eq(nil)
  end

  it 'delivers an order from order page' do
    login_as_admin
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link order.contact.business
    click_link 'Mark Delivered'

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id).fullfilled_on).not_to eq(nil)
  end

  it 'shows delivered orders' do
    login_as_admin
    order    = FactoryBot.create(:order, fullfilled_on: Date.yesterday)
    order_id = order.id
    visit admin_orders_path

    click_link 'Delivered Orders'

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content(order_id)
  end

  it 'shows a delivered order' do
    login_as_admin
    order    = FactoryBot.create(:order, fullfilled_on: Date.yesterday)
    order_id = order.id
    visit edit_admin_order_path(order_id)

    expect(current_path).to eq(admin_order_path(order_id))

    expect(page).to have_content(order_id)
  end

  it 'edits an undelivered order' do
    login_as_admin
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_order_path(order_id)

    expect(current_path).to eq(edit_admin_order_path(order_id))

    expect(page).to have_content(order_id)
  end

  it 'undelivers an order' do
    login_as_admin
    order    = FactoryBot.create(:order, fullfilled_on: Date.yesterday)
    order_id = order.id

    visit admin_orders_path
    click_link 'Delivered Orders'
    click_link order.contact.business
    click_link 'Undeliver'

    expect(current_path).to eq(edit_admin_order_path(order_id))
    expect(Order.find_by_id(order_id).fullfilled_on).to eq(nil)
  end

  it 'views all orders by a contact' do
    login_as_admin
    order = FactoryBot.create(:order)
    visit admin_orders_path

    click_link order.contact.business
    click_link 'View all orders'

    expect(current_path).to eq(admin_orders_path)
  end

  it 'creates some line_items' do
    login_as_admin
    order = FactoryBot.create(:order)
    visit admin_orders_path

    first(:link, 'New Order').click
    expect(current_path).to eq(new_admin_order_path)

    fill_in 'Contact business', with: order.contact.business
    fill_in 'Delivery date', with: order.delivery_date

    click_link 'add line item'
    FactoryBot.create(:line_item, order_id: order.id)
    FactoryBot.create(:line_item, order_id: order.id)

    click_button 'Save'
    expect(current_path).to eq(edit_admin_order_path(order.id + 1))
    expect(order.line_items.count).to eq 2
    expect(page).to have_content('created')
  end

  it 'shows late orders' do
    login_as_admin
    order = FactoryBot.create(:order, delivery_date: Date.yesterday)

    visit admin_orders_path
    click_on 'Late Orders'

    expect(page).to have_content(order.contact.business)
    expect(page).to have_content(order.id)
  end

  it 'creates an invoice' do
    if testing_xero
      puts 'testing xero'
      login_as_admin
      order = FactoryBot.create(:line_item).order

      visit admin_orders_path
      click_link order.contact.business
      click_link 'Create Invoice'

      expect(current_path).to eq(admin_order_path(order))

      expect(page).to have_content('Invoice Status: DRAFT')
    end
  end

  it 'navigates orders' do
    login_as_admin
    o1   = FactoryBot.create(:order, delivery_date: Date.today)
    o2   = FactoryBot.create(:order, delivery_date: Date.today + 2)
    o3   = FactoryBot.create(:order, delivery_date: Date.today + 1)

    visit edit_admin_order_path(o1)
    expect(page).to have_content '<'
    expect(page).to have_content '>'
    click_link '>'
    expect(current_path).to eq(edit_admin_order_path(o3.id))
    click_link '>'
    expect(current_path).to eq(edit_admin_order_path(o2.id))
    click_link '>'
    expect(current_path).to eq(edit_admin_order_path(o1.id))
  end

  it 'fulfills line items' do
    login_as_admin
    p     = FactoryBot.create(:product)
    order = FactoryBot.create(:order)
    order.line_items.append FactoryBot.create(:line_item, product: p, size: LineItem.SIZES.last)

    visit edit_admin_order_path(order)
    check 'order[line_items_attributes][0][fulfilled]'
    first(:button, 'Update').click

    expect(current_path).to eq(edit_admin_order_path(order.id))
  end
end
