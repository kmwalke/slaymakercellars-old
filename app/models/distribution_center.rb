class DistributionCenter < ActiveRecord::Base
  validates_presence_of :name, :phone, :email, :contact_point
  has_many :orders
end
