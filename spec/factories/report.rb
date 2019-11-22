FactoryBot.define do
  factory :report do |f|
    f.report_type Report::REPORTTYPES.first
    f.start_date 1.month.ago
    f.end_date Date.today
    f.sequence(:name) { |n| "Report_#{n}" }
  end
end
