require 'rails_helper'

describe 'Admin::Contacts' do
  it 'opens Admin::Contacts' do
    login_as_admin
    visit admin_contacts_path

    expect(current_path).to eq(admin_contacts_path)
    expect(page).to have_content('Contacts')
  end

  it 'creates a contact' do
    login_as_admin
    contact = FactoryBot.create(:contact)
    visit admin_contacts_path

    first(:link, 'New Contact').click
    expect(current_path).to eq(new_admin_contact_path)

    fill_in 'Name', with: contact.name
    fill_in 'Business', with: contact.business
    fill_in 'Price point', with: '14.0'
    select contact.town.name, from: 'contact_town_id'
    check 'Mark with retail price'
    fill_in 'Price per ounce', with: '1.75'

    first(:button, 'Create Contact').click
    expect(current_path).to eq(edit_admin_contact_path(contact.id + 1))
  end

  it 'updates a contact' do
    login_as_admin
    contact    = FactoryBot.create(:contact)
    contact_id = contact.id
    new_name   = "new #{contact.name}"
    visit admin_contacts_path

    click_link contact.name
    expect(current_path).to eq(edit_admin_contact_path(contact_id))

    fill_in 'Name', with: new_name

    first(:button, 'Update Contact').click
    expect(current_path).to eq(edit_admin_contact_path(contact_id))
    expect(Contact.find_by_id(contact_id).name).to eq(new_name)
  end

  it 'attaches a user to a contact' do
    login_as_admin
    contact    = FactoryBot.create(:contact)
    user       = FactoryBot.create(:user, admin: false)
    contact_id = contact.id
    visit admin_contacts_path

    click_link contact.name
    expect(current_path).to eq(edit_admin_contact_path(contact_id))

    select user.name, from: 'contact_user_id'

    first(:button, 'Update Contact').click
    expect(current_path).to eq(edit_admin_contact_path(contact_id))
    contact = Contact.find_by_id(contact_id)
    expect(contact.user_id).to eq(user.id)

    visit edit_admin_user_path(user.id)
    expect(page).to have_content(contact.business)
  end

  it 'deactivates a contact' do
    login_as_admin
    contact    = FactoryBot.create(:contact)
    contact_id = contact.id
    visit admin_contacts_path

    click_link "delete_#{contact_id}"

    expect(current_path).to eq(admin_contacts_path)
    expect(Contact.find_by_id(contact_id).deleted_at).not_to eq(nil)

    expect(page).not_to have_content(contact.business)
    click_link 'Deleted'
    expect(page).to have_content(contact.business)
  end

  it 'marks a misc a contact' do
    login_as_admin
    contact = FactoryBot.create(:contact)
    visit admin_contacts_path

    click_link contact.name
    select 'Misc.', from: 'contact_status'

    first(:button, 'Update Contact').click

    visit admin_contacts_path
    expect(page).not_to have_content(contact.business)
    click_link 'Misc.'
    expect(page).to have_content(contact.business)
  end

  it 'marks a target a contact' do
    login_as_admin
    contact = FactoryBot.create(:contact)
    visit admin_contacts_path

    click_link contact.name
    select 'Target', from: 'contact_status'

    first(:button, 'Update Contact').click

    visit admin_contacts_path
    expect(page).not_to have_content(contact.business)
    click_link 'Target'
    expect(page).to have_content(contact.business)
  end

  it 'makes an issue' do
    login_as_admin
    contact = FactoryBot.create(:contact)
    visit admin_contacts_path

    click_link contact.name
    click_link 'Add Issue'
    fill_in 'Content', with: 'Test Issue'
    click_button 'Create Issue'

    expect(current_path).to eq(edit_admin_contact_path(contact))
    expect(contact.notes.size).to eq(1)
    expect(contact.notes.first.resolved?).to eq(false)
  end

  it 'resolves an issue' do
    login_as_admin
    contact = FactoryBot.create(:contact)
    visit admin_contacts_path

    click_link contact.name
    click_link 'Add Issue'
    fill_in 'Content', with: 'Test Issue'
    click_button 'Create Issue'

    expect(current_path).to eq(edit_admin_contact_path(contact))
    click_link 'Resolve'
    expect(contact.notes.size).to eq(1)
    expect(contact.notes.first.resolved?).to eq(true)
  end

  it 'links to a new order' do
    login_as_admin
    contact = FactoryBot.create(:contact)
    visit edit_admin_contact_path(contact)

    click_link 'New order'
    expect(current_path).to eq new_admin_order_path
    expect(find_field('Contact business').value).to eq(contact.business)
  end

  it 'repeats the last order' do
    login_as_admin
    contact   = FactoryBot.create(:contact)
    old_order = FactoryBot.create(:order, contact_id: contact.id)
    new_id    = old_order.id + 1
    visit edit_admin_contact_path(contact)

    click_link 'Repeat last order'
    expect(current_path).to eq edit_admin_order_path(contact.orders.last)
    expect(find_field('Contact business').value).to eq(contact.business)
    click_link 'Orders'
    expect(page).to have_content new_id
  end

  it 'searches for a contact' do
    login_as_admin
    100.times do
      FactoryBot.create(:contact)
    end
    contact = FactoryBot.create(:contact, business: 'zzzbusiness')

    visit admin_contacts_path
    expect(page).not_to have_content contact.business
    fill_in 'search', with: 'ZzZ'
    click_button 'Search'

    expect(current_path).to eq(admin_contacts_path)
    expect(page).to have_content contact.business
  end
end
