require 'spec_helper'

describe 'Admin::Products' do
  it 'opens Admin::Products' do
    login_as_admin
    visit admin_products_path

    expect(current_path).to eq(admin_products_path)
    expect(page).to have_content('Products')
  end

  it 'creates a public product' do
    login_as_admin
    product = FactoryBot.create(:product)
    visit admin_products_path

    first(:link, 'New Cheese').click
    expect(current_path).to eq(new_admin_product_path)

    fill_in 'Name', with: product.name
    fill_in 'Desc', with: product.desc
    check "Show on 'Cheeses' Page"

    click_button 'Create Product'
    expect(current_path).to eq(admin_products_path)

    click_link 'Logout'
    visit products_path
    expect(page).to have_content product.name
  end

  it 'creates a private product' do
    login_as_admin
    product = FactoryBot.create(:product)
    visit admin_products_path

    first(:link, 'New Cheese').click
    expect(current_path).to eq(new_admin_product_path)

    fill_in 'Name', with: product.name
    fill_in 'Desc', with: product.desc

    click_button 'Create Product'
    expect(current_path).to eq(admin_products_path)

    click_link 'Logout'
    visit products_path
    expect(page).not_to have_content product.name
  end

  it 'creates an inactive product' do
    login_as_admin
    product = FactoryBot.create(:product)
    visit admin_products_path

    first(:link, 'New Cheese').click
    expect(current_path).to eq(new_admin_product_path)

    fill_in 'Name', with: product.name
    fill_in 'Desc', with: product.desc
    check "Show on 'Cheeses' Page"

    click_button 'Create Product'
    expect(current_path).to eq(admin_products_path)

    visit new_admin_product_path

    click_link 'Logout'
    visit products_path
    expect(page).to have_content product.name
    expect(page).not_to have_content 'Currently Available'
  end

  it 'updates a product' do
    login_as_admin
    product    = FactoryBot.create(:product)
    product_id = product.id
    new_name   = "new #{product.name}"
    visit admin_products_path

    click_link product.name
    expect(current_path).to eq(edit_admin_product_path(product_id))

    fill_in 'Name', with: new_name

    click_button 'Update Product'
    expect(current_path).to eq(admin_products_path)
    expect(Product.find_by_id(product_id).name).to eq(new_name)
  end

  it 'deletes a product' do
    login_as_admin
    product    = FactoryBot.create(:product)
    product_id = product.id
    visit admin_products_path

    click_link "delete_#{product.id}"

    expect(current_path).to eq(admin_products_path)
    expect(Product.find_by_id(product_id)).to eq(nil)
  end
end
