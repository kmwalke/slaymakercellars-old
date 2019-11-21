class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  SIZES         = ['Wheel', 'Retail (4oz Vacuum)', 'Retail (8oz Paper)', 'LBs', '32oz Tub'].freeze
  ACCOUNT_CODES = {
    self.SIZES[0] => 410,
    self.SIZES[1] => 414,
    self.SIZES[2] => 414,
    self.SIZES[3] => 410,
    self.SIZES[4] => 415
  }.freeze
end
