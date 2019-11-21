require 'spec_helper'

describe 'Sessions' do
  it 'keeps the riffraff out' do
    user = FactoryBot.create(:user)

    visit admin_path
    expect(current_path).to eq(login_path)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'WrongPassword'
    click_button 'Log In'

    expect(current_path).to eq(login_path)
    expect(page).to have_content('Invalid')
  end

  it 'logs in users' do
    user = FactoryBot.create(:user, admin: false)

    visit user_orders_path
    expect(current_path).to eq(login_path)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'

    expect(current_path).to eq(user_orders_path)
    expect(page).to have_content('Logout')
  end

  it 'logs out users' do
    login

    visit user_orders_path
    click_link 'Logout'

    expect(current_path).to eq(root_path)
    visit user_orders_path
    expect(current_path).to eq(login_path)
    expect(page).to have_content('You must')
  end

  it 'restricts users to their own order page' do
    login

    visit admin_path
    expect(current_path).to eq(user_orders_path)
    expect(page).to have_content('You must')
  end

  it 'logs in admins' do
    user = FactoryBot.create(:user, admin: true)

    visit admin_path
    expect(current_path).to eq(login_path)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'

    expect(current_path).to eq(admin_path)
    expect(page).to have_content('Administration')
  end

  it 'redirect admins to requested page' do
    user = FactoryBot.create(:user, admin: true)

    visit admin_orders_path
    expect(current_path).to eq(login_path)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content('Active Orders')
  end

  it 'logs out admins' do
    login_as_admin

    visit admin_path
    click_link 'Logout'

    expect(current_path).to eq(root_path)
    visit admin_path
    expect(current_path).to eq(login_path)
    expect(page).to have_content('You must')
  end
end
