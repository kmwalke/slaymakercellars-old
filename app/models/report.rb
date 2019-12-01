class Report < ActiveRecord::Base
  validates_presence_of :report_type, :name

  validates :name, uniqueness: true

  REPORT_TYPES = [
    'Orders by Item',
    'Orders by Account',
    'Orders by Salesperson'
  ].freeze
end
