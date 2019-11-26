require 'rails_helper'

describe 'Admin::Users' do
  it 'opens Admin::Users' do
    login_as_admin
    visit admin_users_path

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content('Users')
  end

  it 'creates an user' do
    login_as_admin

    user = FactoryBot.create(:user)
    visit admin_users_path

    first(:link, 'New User').click
    expect(current_path).to eq(new_admin_user_path)

    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Create User'
    expect(current_path).to eq(admin_users_path)
  end

  it 'updates an user' do
    login_as_admin

    user     = FactoryBot.create(:user)
    user_id  = user.id
    new_name = "new #{user.name}"
    visit admin_users_path

    click_link user.name
    expect(current_path).to eq(edit_admin_user_path(user_id))

    fill_in 'Name', with: new_name

    click_button 'Update User'
    expect(current_path).to eq(admin_users_path)
    expect(User.find_by_id(user_id).name).to eq(new_name)
  end

  it 'archives an user' do
    login_as_admin
    user    = FactoryBot.create(:user)
    user_id = user.id
    visit admin_users_path

    click_link "delete_#{user.id}"

    expect(current_path).to eq(admin_users_path)
    expect(User.find_by_id(user_id).active?).to eq(false)
    expect(page).not_to have_content(User.find_by_id(user_id).name)
  end

  it 'denies login to archived user' do
    user = FactoryBot.create(:user, admin: true, deleted_at: DateTime.now)
    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Log In'

    expect(current_path).to eq(login_path)
    expect(page).to have_content('Invalid')
  end

  it 'unarchives an user' do
    login_as_admin
    user2    = FactoryBot.create(:user, admin: true, deleted_at: DateTime.now)
    user2_id = user2.id

    visit admin_users_path

    click_link 'Inactive Users'
    click_link user2.name
    click_link 'Restore User'

    expect(current_path).to eq(admin_users_path)
    expect(User.find_by_id(user2_id).active?).to eq(true)
  end
end
