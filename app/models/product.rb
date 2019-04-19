# == Schema Information
#
# Table name: products
#
#  id                  :bigint(8)        not null, primary key
#  title               :string
#  product_id          :string
#  price               :float
#  currency            :string
#  blog_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class Product < ApplicationRecord
  belongs_to :blog
  has_one_attached :avatar


  def attach_avatar(url)
    uri = URI.parse(url)
    download_image = open(url)
    basename = File.basename(uri.path)
    extname = File.extname(uri.path).remove('.')
    self.avatar.attach(io: download_image, filename: basename, content_type: "image/#{extname}")
  end
end
