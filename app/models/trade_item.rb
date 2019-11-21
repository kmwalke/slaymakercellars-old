class TradeItem < ActiveRecord::Base
  validates_presence_of :file_file_size
  has_attached_file :file,
                    storage: :s3,
                    s3_credentials: {
                      access_key_id: ENV['S3_KEY'] || 'AKIAJFUKVOAMPOJSYJLA',
                      secret_access_key: ENV['S3_SECRET'] || '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'
                    },

                    #    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    path: ':class/:attachment/:id/:style/:basename.:extension',
                    bucket: 'kwac'
end
