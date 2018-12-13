class Page < ApplicationRecord
  has_attached_file :image,
                    :default_url => "/assets/katerina-radvanska-397105-unsplash.jpg",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename",
                    styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
