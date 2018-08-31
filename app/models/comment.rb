class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  has_many :comment_actions
end
