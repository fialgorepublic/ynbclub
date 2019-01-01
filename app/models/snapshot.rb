class Snapshot < ApplicationRecord
  has_attached_file :step1_avatar,
                    :default_url => "/assets/katerina-radvanska-397105-unsplash.jpg",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename"

  has_attached_file :step2_avatar,
                    :default_url => "/assets/katerina-radvanska-397105-unsplash.jpg",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename"
  has_attached_file :step3_avatar,
                    :default_url => "/assets/katerina-radvanska-397105-unsplash.jpg",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename"
  has_attached_file :step4_avatar,
                    :default_url => "/assets/katerina-radvanska-397105-unsplash.jpg",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename"

  validates_attachment_content_type :step1_avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :step2_avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :step3_avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :step4_avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


  def delete_avatar?(id)
    return step1_avatar.destroy if id == "step1"
    return step2_avatar.destroy if id == "step2"
    return step3_avatar.destroy if id == "step3"
    step4_avatar.destroy if id == "step4"
  end
end
