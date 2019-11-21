class User < ActiveRecord::Base
  has_many :orders, foreign_key: 'created_by_id'
  has_many :orders, foreign_key: 'updated_by_id'
  has_many :contacts, foreign_key: 'updated_by_id'
  has_one :contact
  validates :email, presence: true
  validates :password, presence: true, on: create

  has_attached_file :photo,
                    default_url: '/assets/blank-user.png',
                    styles: {
                      thumb: '64x128',
                      small: '250x526',
                      large: '800X613>'
                    },
                    #    :storage => :s3,
                    #    :s3_credentials => {
                    #      :access_key_id => ENV['S3_KEY'] || 'AKIAJFUKVOAMPOJSYJLA',
                    #      :secret_access_key => ENV['S3_SECRET'] || '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'
                    #    },

                    #    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    path: ':class/:attachment/:id/:style/:basename.:extension' # ,
  #    :bucket => "kwac"

  has_secure_password

  has_many :notes

  def active?
    deleted_at.nil?
  end
end
