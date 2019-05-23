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
  extend FriendlyId
  friendly_id do |config|
    config.base = :title
    config.use :slugged
    config.use Module.new {
      def normalize_friendly_id(text)
        text.to_slug.normalize! :transliterations => [:vietnamese]
      end
    }
  end

  belongs_to :category, optional: true
  belongs_to :user,     optional: true
  has_many :comments
  has_many :likes
  has_many :products, :dependent => :destroy
  has_many :blog_views, :dependent => :destroy
  has_many :share_urls, :dependent => :destroy
  has_one_attached :avatar

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

  scope :filter_by_category,  -> (category) { where(category_id: category) }
  scope :all_published_blogs, -> (sort_type, category) {
    sort_by = sort_type.present? ? sort_type : 0
    category = category.present? ? category : Category.ids
    where(is_published: true).filter_by_category(category).sort_blogs(sort_by)
  }
  scope :first_three_latest_blogs, -> { where(is_published: true).order(updated_at: :desc).first(3) }
  scope :eager_load_objects , -> { includes(:category, :user, :comments, :likes, :products, :blog_views, :share_urls).with_attached_avatar }
  # Ex:- scope :active, -> {where(:active => true)}
  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :full_name, :name, :email, to: :user, prefix: true, allow_nil: true

  after_create :add_coins_to_user_account

  def add_products(product)
    return if product.blank?
    if product[:product_id].present?
      product[:product_id].each_with_index do |value, index|
        new_product = Product.create(product_id: value, title: product[:title][index], price: product[:price][index],
                       blog_id: self.id, url: "https://www.saintlbeau.com/products/#{product[:handle][index]}")
        new_product.attach_avatar(product[:avatar][index])
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
        new_product = Product.create(product_id: value, title: product[:title][index], price: product[:price][index],
                       blog_id: self.id, url: "https://www.saintlbeau.com/products/#{product[:handle][index]}")
        new_product.attach_avatar(product[:avatar][index])
      end
    end

  end

  def attach_default_image
    self.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-blog-image.jpg')), filename: 'default-blog-image.jpg', content_type: 'image/jpg')
  end

  def default_image?
    self.avatar.filename == 'default-blog-image.jpg'
  end

  private
    def add_coins_to_user_account
      point_type = PointType.find_by_name('Post the blog (Ghi bài Blog)')
      return if point_type.blank?
      user.points.create(point_type: point_type, point_value: point_type.point, invitee: "Posted new blog")
    end

    def should_generate_new_friendly_id?
      title_changed?
    end

end
