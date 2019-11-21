class Product < ActiveRecord::Base
  has_many :line_items
  has_attached_file :photo,
                    default_url: '/assets/cheese.png',
                    styles: {
                      thumb: '64x128',
                      small: '250x526',
                      large: '800X613>'
                    }
  #    :storage => :s3,
  #    :s3_credentials => {
  #      :access_key_id => ENV['S3_KEY'] || 'AKIAJPVVOIS6RQSVFXGQ',
  #      :secret_access_key => ENV['S3_SECRET'] || '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'
  #    },

  #    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
  #    :path => "app/assets/attachments/:class/:id/:style/:basename.:extension",
  #    :bucket => "kwac"

  validates_attachment :photo, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  validates_presence_of :xero_item_code

  def self.TYPES
    ['Year Round', 'Seasonal', 'Reserve', 'Miscellaneous']
  end
end
