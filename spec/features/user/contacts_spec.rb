require 'rails_helper'

describe 'User::Contacts' do
  it 'updates a contact' do
    user       = login
    contact    = FactoryBot.create(:contact, user_id: user.id)
    new_email  = 'new_' + contact.email
    visit user_orders_path
    click_link 'Account'

    fill_in 'Email', with: new_email

    first(:button, 'Update Contact').click
    expect(page).to have_content('updated')
  end
end
