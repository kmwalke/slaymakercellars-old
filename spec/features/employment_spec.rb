require 'spec_helper'

describe 'Employment' do
  it 'renders hompage' do
    visit employment_path

    expect(current_path).to eq(employment_path)

    expect(page).to have_content('Jobs at KWAC')
  end
end
