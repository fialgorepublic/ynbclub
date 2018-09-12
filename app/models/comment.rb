class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  has_many :comment_actions
  belongs_to :parent, :class_name => 'Comment', :foreign_key => 'parent_id', optional: true
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id'
end
