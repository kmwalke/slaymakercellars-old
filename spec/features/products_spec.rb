require 'rails_helper'

describe 'Products' do
  it 'renders products page' do
    visit root_path
    click_link 'Cheese'
    expect(current_path).to eq(products_path)
  end

  it 'renders products categories' do
    products = []
    (0...Product.TYPES.count).each do |i|
      products[i] = FactoryBot.create(:product, category: Product.TYPES[i])

      visit products_path
      first(:link, Product.TYPES[i]).click

      expect(page).to have_content(Product.TYPES[i])
    end
    expect(Product.count).to eq(Product.TYPES.count)
  end

  it 'shows products in production' do
    in_prod = FactoryBot.create(:product, in_production: true, is_public: true)
    visit products_path
    expect(page).to have_content(in_prod.name)
    expect(page).not_to have_content('Out of Stock')

    out_prod = FactoryBot.create(:product, in_production: false, is_public: true)

    visit products_path
    expect(page).to have_content(out_prod.name)
    expect(page).to have_content('Out of Stock')
  end
end
