class Follow < ApplicationRecord
  belongs_to :follower,  foreign_key: :follower_id,  class_name: 'User', counter_cache: :following_count
  belongs_to :following, foreign_key: :following_id, class_name: 'User', counter_cache: :followers_count
end
