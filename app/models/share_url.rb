class ShareUrl < ApplicationRecord
  belongs_to :user
  belongs_to :blog, optional: true

  delegate :title, to: :blog, prefix: true, allow_nil: true

  before_create :set_shared_website

  def set_shared_website
    return self.url_type = "facebook" if url.include?("facebook")
    self.url_type = "twitter" if url.include?("twitter")
  end
end
