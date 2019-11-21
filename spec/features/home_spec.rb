require 'spec_helper'

describe 'Home' do
  it 'renders hompage' do
    visit root_path

    expect(current_path).to eq(root_path)

    expect(page).to have_content('Our Story')
  end
end
