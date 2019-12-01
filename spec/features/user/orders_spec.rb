require 'rails_helper'

describe 'User::Orders' do
  it 'opens User::Orders' do
    login
    visit user_orders_path

    expect(current_path).to eq(user_orders_path)
    expect(page).to have_content('Orders')
  end

  it 'creates an order' do
    user  = login
    order = FactoryBot.create(:order, contact_id: user.contact.id)
    FactoryBot.create(:user, admin: true)
    visit user_orders_path

    first(:link, 'New Order').click
    expect(current_path).to eq(new_user_order_path)

    fill_in 'Delivery Date (DD-MM-YYYY)', with: order.delivery_date

    click_button 'Save'
    expect(current_path).to eq(edit_user_order_path(order.id + 1))
    expect(page).to have_content('created')
  end

  it 'updates an order' do
    user     = login
    order    = FactoryBot.create(:order, contact_id: user.contact.id)
    FactoryBot.create(:user, admin: true)
    order_id = order.id
    new_date = order.delivery_date + 1
    visit user_orders_path

    click_link order.contact.business
    expect(current_path).to eq(edit_user_order_path(order_id))

    fill_in 'Delivery Date (DD-MM-YYYY)', with: new_date

    first(:button, 'Update').click
    expect(current_path).to eq(edit_user_order_path(order_id))
    expect(Order.find_by_id(order_id).delivery_date).to eq(new_date)

    fill_in 'Delivery Date (DD-MM-YYYY)', with: new_date + 1
    first(:button, 'Update').click
    expect(current_path).to eq(edit_user_order_path(order_id))
    expect(Order.find_by_id(order_id).delivery_date).to eq(new_date + 1)
  end

  it 'records users creating orders' do
    user  = login
    order = FactoryBot.create(:order, contact_id: user.contact.id, created_by: user)
    visit edit_user_order_path(order.id)

    expect(page).to have_content('Created by')
    expect(page).to have_content(user.name)
  end

  it 'records users updating orders' do
    user  = login
    order = FactoryBot.create(:order, contact_id: user.contact.id, created_by: user)
    FactoryBot.create(:user, admin: true)

    visit edit_user_order_path(order.id)
    new_date = order.delivery_date + 1
    fill_in 'Delivery Date (DD-MM-YYYY)', with: new_date

    first(:button, 'Update').click

    visit edit_user_order_path(order.id)
    expect(page).to have_content('Updated by')
    expect(page).to have_content(user.name)
  end

  it 'deletes an order from index' do
    user     = login
    order    = FactoryBot.create(:order, contact_id: user.contact.id)
    order_id = order.id
    visit user_orders_path

    click_link "void_#{order.id}"

    expect(current_path).to eq(user_orders_path)
    expect(Order.find_by_id(order_id)).to eq(nil)
  end

  it 'deletes an order from order page' do
    user     = login
    order    = FactoryBot.create(:order, contact_id: user.contact.id)
    order_id = order.id
    visit user_orders_path

    click_link order.contact.business
    click_link 'Void'

    expect(current_path).to eq(user_orders_path)
    expect(Order.find_by_id(order_id)).to eq(nil)
  end

  it 'creates some line_items' do
    user  = login
    order = FactoryBot.create(:order, contact_id: user.contact.id)
    FactoryBot.create(:user, admin: true)
    visit user_orders_path

    first(:link, 'New Order').click
    expect(current_path).to eq(new_user_order_path)

    fill_in 'Delivery Date (DD-MM-YYYY)', with: order.delivery_date

    click_link 'add line item'
    FactoryBot.create(:line_item, order_id: order.id)
    FactoryBot.create(:line_item, order_id: order.id)

    click_button 'Save'
    expect(order.line_items.count).to eq 2
    expect(current_path).to eq(edit_user_order_path(order.id + 1))
    expect(page).to have_content('created')
  end

  it 'shows late orders' do
    user  = login
    order = FactoryBot.create(:order, contact_id: user.contact.id, delivery_date: Date.yesterday)

    visit user_orders_path
    click_on 'Late Orders'

    expect(page).to have_content(order.contact.business)
    expect(page).to have_content(order.id)
  end

  it 'shows delivered orders' do
    user  = login
    order = FactoryBot.create(:order, contact_id: user.contact.id, fulfilled_on: Date.yesterday)

    visit user_orders_path
    click_on 'Delivered Orders'

    expect(page).to have_content(order.contact.business)
    expect(page).to have_content(order.id)
  end
end
