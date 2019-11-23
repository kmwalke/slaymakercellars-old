require 'rails_helper'

describe 'Admin::Home' do
  it 'has an orders control panel' do
    login_as_admin
    FactoryBot.create(:order)
    FactoryBot.create(:order)
    FactoryBot.create(:order)
    late_order = FactoryBot.create(:order, delivery_date: Date.yesterday)

    visit admin_path
    click_link 'New Order'
    expect(current_path).to eq(new_admin_order_path)

    visit admin_path
    click_link '1 order late'
    expect(current_path).to eq(edit_admin_order_path(late_order))

    visit admin_path
    click_link '3 orders to fulfill today'
    expect(current_path).to eq(admin_orders_path)

    visit admin_path
    click_link '4 orders in total'
    expect(current_path).to eq(admin_orders_path)
  end

  it 'has a contacts control panel' do
    login_as_admin

    visit admin_path
    click_link 'New Contact'
    expect(current_path).to eq(new_admin_contact_path)
  end

  it 'has a reports control panel' do
    login_as_admin

    visit admin_path
    click_link 'New Report'
    expect(current_path).to eq(new_admin_report_path)
  end

  it 'has a news control panel' do
    login_as_admin

    visit admin_path
    click_link 'New Article'
    expect(current_path).to eq(new_admin_article_path)
  end

  it 'has a products panel' do
    login_as_admin

    visit admin_path
    click_link 'New Product'
    expect(current_path).to eq(new_admin_product_path)
  end

  it 'has a DC panel' do
    login_as_admin

    visit admin_path
    click_link 'New Distribution Center'
    expect(current_path).to eq(new_admin_distribution_center_path)
  end
end
