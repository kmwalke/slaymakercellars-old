require 'spec_helper'

describe 'Admin::Fulfillment' do
  it 'opens Admin::Fulfillment' do
    user = login_as_admin
    visit admin_fulfillment_path

    expect(current_path).to eq(admin_fulfillment_path)
    expect(page).to have_content('Fulfillment')
  end

  it "Shows  orders on today's fulfillment" do
    user  = login_as_admin
    order = FactoryBot.create(:order, delivery_date: Date.today)
    li1   = FactoryBot.create(:line_item, order_id: order.id)

    visit admin_fulfillment_path

    expect(page).to have_content('1.0')
  end

  it "Shows late orders on today's fulfillment" do
    user  = login_as_admin
    order = FactoryBot.create(:order, delivery_date: Date.today - 2)
    li1   = FactoryBot.create(:line_item, order_id: order.id)

    visit admin_fulfillment_path

    expect(page).to have_content('1.0')
  end

  it 'does not show fulfilled items' do
    user  = login_as_admin
    p = FactoryBot.create(:product)
    order = FactoryBot.create(:order)
    order.line_items.append FactoryBot.create(:line_item, product: p, size: LineItem.SIZES.last, fulfilled: true)

    visit admin_fulfillment_path
    expect(page).not_to have_content('1.0')
  end
end
