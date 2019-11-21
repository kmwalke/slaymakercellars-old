class Town < ActiveRecord::Base
  has_many :contacts
  belongs_to :state

  def full_name
    name + ', ' + state.name
  end
end
