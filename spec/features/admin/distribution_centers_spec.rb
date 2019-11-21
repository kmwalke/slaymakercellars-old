require 'spec_helper'

describe 'DistributionCenters' do
  it 'opens Admin::DistributionCenters' do
    login_as_admin
    visit admin_distribution_centers_path

    expect(current_path).to eq(admin_distribution_centers_path)
    expect(page).to have_content('Distribution Centers')
  end

  it 'creates a DC' do
    login_as_admin
    dc = FactoryBot.create(:distribution_center)
    dc.id
    visit admin_distribution_centers_path

    first(:link, 'New Distribution Center').click
    expect(current_path).to eq(new_admin_distribution_center_path)

    fill_in 'Name', with: dc.name
    fill_in 'Email', with: dc.email
    fill_in 'Phone', with: dc.phone
    fill_in 'Contact point', with: dc.contact_point

    first(:button, 'Create Distribution center').click
    expect(current_path).to eq(edit_admin_distribution_center_path(dc.id + 1))
  end

  it 'updates a DC' do
    login_as_admin
    dc       = FactoryBot.create(:distribution_center)
    dc_id    = dc.id
    new_name = "new #{dc.name}"
    visit admin_distribution_centers_path

    click_link dc.name
    expect(current_path).to eq(edit_admin_distribution_center_path(dc_id))

    fill_in 'Name', with: new_name

    first(:button, 'Update Distribution center').click
    expect(current_path).to eq(edit_admin_distribution_center_path(dc_id))
    expect(DistributionCenter.find_by_id(dc_id).name).to eq(new_name)
  end

  it 'deletes a DC' do
    login_as_admin
    dc    = FactoryBot.create(:distribution_center)
    dc_id = dc.id
    visit admin_distribution_centers_path

    click_link "delete_#{dc_id}"

    expect(current_path).to eq(admin_distribution_centers_path)
    expect(DistributionCenter.find_by_id(dc_id)).to eq(nil)

    expect(page).not_to have_content(dc.name)
  end
end
