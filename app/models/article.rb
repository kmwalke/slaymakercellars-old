class Article < ActiveRecord::Base
  validates :title, :date, presence: true
end
