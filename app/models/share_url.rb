class ShareUrl < ApplicationRecord
  belongs_to :user
  belongs_to :blog, optional: true

  delegate :title, to: :blog, prefix: true, allow_nil: true

  before_create :set_shared_website

  scope :shared_media_urls, -> { where(blog_id: nil) }

  def set_shared_website
    return if url.blank?
    return self.url_type = "facebook" if url.include?("facebook")
    return self.url_type = "twitter" if url.include?("twitter")
    self.url_type = "instagram" if url.include?("instagram")
  end
end
