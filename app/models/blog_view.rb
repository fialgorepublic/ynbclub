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
  belongs_to :blog
end
