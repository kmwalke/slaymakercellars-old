require 'rails_helper'

describe 'Admin::Reports' do
  it 'opens Admin::Reports' do
    login_as_admin
    visit admin_reports_path

    expect(current_path).to eq(admin_reports_path)
    expect(page).to have_content('Reports')
  end

  it 'creates a report' do
    login_as_admin

    visit admin_reports_path

    first(:link, 'New Report').click
    expect(current_path).to eq(new_admin_report_path)

    fill_in 'Name', with: 'This is a report'

    click_button 'Create Report'
    #    expect(current_path).to eq(admin_report_path)
  end

  it 'edits a report' do
    login_as_admin
    report = FactoryBot.create(:report)
    visit admin_reports_path

    first(:link, 'Show').click
    first(:link, 'Edit Report').click
    expect(current_path).to eq(edit_admin_report_path(report))

    fill_in 'Name', with: 'new name'

    click_button 'Update Report'
    expect(page).to have_content 'new name'
  end

  it 'deletes a report' do
    login_as_admin
    report    = FactoryBot.create(:report)
    report_id = report.id
    visit admin_reports_path

    click_link "delete_#{report.id}"

    expect(current_path).to eq(admin_reports_path)
    expect(Report.find_by_id(report_id)).to eq(nil)
  end

  it 'checks sales activity' do
    login_as_admin
    visit admin_path

    click_link 'Sales Activity'

    expect(current_path).to eq(admin_path)
    expect(page).to have_content 'Sales Activity has been emailed to admins.'
  end
end
