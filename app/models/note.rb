class Note < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user

  def resolved?
    !deleted_at.nil?
  end
end
