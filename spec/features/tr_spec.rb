require 'rails_helper'

describe 'Tr' do
  it 'renders hompage' do
    visit tr_path

    expect(current_path).to eq(tr_path)

    #    expect(page).to have_content("Jobs at KWAC")
  end
end
