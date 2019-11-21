require 'spec_helper'

describe 'Accounts' do
  it 'renders account page' do
    visit root_path
    click_link 'Where'
    expect(current_path).to eq(accounts_path)
  end

  it 'renders public contacts' do
    contact = FactoryBot.create(:contact, is_public: true)

    visit accounts_path
    expect(page).to have_content(contact.business)
  end

  it "doesn't render private contacts" do
    contact = FactoryBot.create(:contact, is_public: false)

    visit accounts_path
    expect(page).to_not have_content(contact.business)
  end
end
