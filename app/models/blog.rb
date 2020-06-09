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

  scope :published_and_drafted_blogs, -> (user_id) { published.or(where(is_published: false, user_id: user_id))}

  scope :all_users_blogs, -> { where.not(user_id: nil).order(is_published: :asc) }
  scope :today, -> {where(created_at: Date.today.midnight .. Date.today.end_of_day)}

  scope :sorted_by, -> (sort_type) {
    case sort_type
      when 0, "0"
        order(created_at: :desc, is_published: :desc)
      when 1, "1"
        order(title: :asc, is_published: :desc )
      when 2, "2"
        order(title: :desc, is_published: :desc)
      when 3, "3"
        order(created_at: :desc)
      when 4, "4"
        order(created_at: :asc)
      when -1, "-1"
        order(is_published: :desc, updated_at: :desc)
    end
  }

  scope :filter_by_category,  -> (category) { where(category_id: category) }
  scope :all_published_blogs, -> (sort_type, category, title) {
    sort_by = sort_type.present? ? sort_type : 0
    category = category.present? ? category : Category.ids
    where(is_published: true).filter_by_category(category).search_by_title(title).sort_blogs(sort_by)
  }
  scope :first_three_latest_blogs, -> { where(is_published: true).order(updated_at: :desc).first(3) }
  scope :eager_load_objects , -> { includes(:category, :comments, :likes, :products, :share_urls, :blog_views, user: :profile).with_attached_avatar }
  scope :search_by_title, -> (title) { where('lower(title) like ?', "%#{title&.downcase}%")  }
  scope :published, -> { where(is_published: true) }
  scope :valid_blogs, -> { where.not(user_id: nil) }
  scope :latest, -> { order(created_at: :desc) }

  # Ex:- scope :active, -> {where(:active => true)}
  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :full_name, :name, :email, to: :user, prefix: true, allow_nil: true

  before_destroy :valid_for_destroy?

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
    avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-blog-image.jpg')), filename: 'default-blog-image.jpg', content_type: 'image/jpg')
  end

  def default_image?
    avatar.filename == 'default-blog-image.jpg'
  end

  def reject!(status)
    update_attributes(rejected: status)
  end

  def award_coins!
    return if coins_awarded?
    point_type = PointType.find_by_name('Post the blog (Ghi bài Blog)')
      return if point_type.blank? || point_type.zero_points?

    point = user.points.create(point_type: point_type, point_value: point_type.point, invitee: "Posted new blog")
    user.add_points!(point.point_value) unless point.errors.any?
    update(coins_awarded: true)
  end

   def publish!
    update_attributes(is_published: true)
  end

  def unpublish!
    update_attributes(is_published: false)
  end

  private
    def should_generate_new_friendly_id?
      title_changed?
    end

    def valid_for_destroy?
      unless ( ( DateTime.now.to_time.utc - self.created_at.to_time.utc ) / 1.hours ) > 42
        point_type = PointType.find_by_name('Post the blog (Ghi bài Blog)')
        return if point_type.blank?
        point = user.points.where(point_type: point_type).last
        point.destroy if point.present?
      end
    end



end
