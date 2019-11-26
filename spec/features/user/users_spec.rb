require 'rails_helper'

describe 'User::Users' do
  it 'updates an user' do
    user     = login
    user_id  = user.id
    new_name = "new #{user.name}"
    visit user_orders_path

    click_link 'Change Login'
    expect(current_path).to eq(edit_user_user_path(user_id))

    fill_in 'Name', with: new_name

    click_button 'Update User'
    expect(current_path).to eq(edit_user_user_path(user_id))
    expect(User.find_by_id(user_id).name).to eq(new_name)
  end
end
