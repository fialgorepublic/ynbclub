# == Schema Information
#
# Table name: blogs
#
#  id                  :bigint(8)        not null, primary key
#  title               :string
#  promote_post        :string
#  description         :text
#  category_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  is_featured         :boolean          default(FALSE)
#  feature_date        :datetime
#  is_published        :boolean          default(FALSE)
#  buyer_show          :boolean          default(FALSE)
#  user_id             :bigint(8)
#

class Blog < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :comments
  has_many :likes
  has_many :products, :dependent => :destroy
  has_many :blog_views, :dependent => :destroy
  has_many :share_urls, :dependent => :destroy
  has_attached_file :avatar,
                    :default_url => "/images/:style/missing.png",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename",
                    styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  scope :published_and_drafted_blogs, -> (user_id) { where(is_published: true).or(where(is_published: false, user_id: user_id))}

  scope :sort_blogs, -> (sort_type) {
    case sort_type
      when 0, "0"
        order(created_at: :desc, is_published: :desc)
      when 1, "1"
        order(title: :asc, is_published: :desc )
      when 2, "2"
        order(title: :desc, is_published: :desc)
      when -1, "-1"
        order(is_published: :desc, updated_at: :desc)
    end
  }

  delegate :name, to: :category, prefix: true
  delegate :full_name, :name, to: :user, prefix: true, allow_nil: true

  def add_products(product)
    return if product.blank?
    if product[:product_id].present?
      product[:product_id].each_with_index do |value, index|
        Product.create(product_id: value, title: product[:title][index], price: product[:price][index],
                       blog_id: self.id, avatar: product[:avatar][index])
      end
    end
    # products = Product.where("id IN (?)", product_ids)
    # if products.any?
    #   products.each do |product|
    #     self.products << product
    #   end
    # end
  end

  def update_products(product)
    return if product.blank?
    self.products.delete_all
    if product[:product_id].present?
      product[:product_id].each_with_index do |value, index|
        Product.create(product_id: value, title: product[:title][index], price: product[:price][index],
                       blog_id: self.id, avatar: product[:avatar][index])
      end
    end

  end
end
