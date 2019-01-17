# == Schema Information
#
# Table name: share_urls
#
#  id         :bigint(8)        not null, primary key
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  blog_id    :integer
#  url_type   :string
#

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
