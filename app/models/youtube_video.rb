class YoutubeVideo < ApplicationRecord
  has_one_attached :thumbnail
  default_scope { order(created_at: :desc) }
end
