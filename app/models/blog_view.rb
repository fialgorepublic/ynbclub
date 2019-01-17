# == Schema Information
#
# Table name: blog_views
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  blog_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlogView < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  validates :user_id, uniqueness: { scope: :blog_id }

end
