# == Schema Information
#
# Table name: comments
#
#  id         :bigint(8)        not null, primary key
#  message    :string
#  user_id    :integer
#  blog_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#

class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  has_many :comment_actions
  belongs_to :parent, :class_name => 'Comment', :foreign_key => 'parent_id', optional: true
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id'
end
