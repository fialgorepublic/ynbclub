# == Schema Information
#
# Table name: pages
#
#  id                 :bigint(8)        not null, primary key
#  heading            :string
#  sub_heading        :string
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Page < ApplicationRecord
  has_one_attached :image
  has_one_attached :blog_banner
  has_one_attached :snapshot_banner
  has_one_attached :group_banner
  has_one_attached :conversation_banner
end
