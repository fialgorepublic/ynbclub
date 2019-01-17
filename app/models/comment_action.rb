# == Schema Information
#
# Table name: comment_actions
#
#  id         :bigint(8)        not null, primary key
#  like       :boolean
#  user_id    :bigint(8)
#  comment_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CommentAction < ApplicationRecord
  belongs_to :user
  belongs_to :comment
end
