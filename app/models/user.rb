# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  name                   :string
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer
#  referral               :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  social_login           :boolean          default(FALSE)
#  commission             :float
#  phone_number           :string
#  shop_no                :string
#  money                  :string
#  is_activated           :boolean          default(FALSE)
#  is_shopify_user        :boolean          default(FALSE)
#  identity_card          :string
#  surplus                :string
#  paid                   :string
#  total_income           :float
#  status                 :string
#  banned                 :boolean          default(FALSE)
#

class User < ApplicationRecord
  self.per_page = 500
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :referral, uniqueness: true, if: :is_ambassador?
  belongs_to :role, optional: true
  has_many :referral_sales
  has_many :payments
  has_many :points
  has_many :share_urls
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, :allow_destroy => true
  has_many :comments
  has_many :likes
  has_many :comment_actions
  has_many :blogs
  has_many :exchange_histories
  has_many :permissions
  has_many :notifications, foreign_key: 'target_id'
  has_many :commission_histories
  has_many :joined_groups
  has_many :groups, through: :joined_groups
  has_many :conversations

  has_one_attached :avatar

  delegate :first_name, :surname, :address_line_1, :address_line_2, :city, :state, :zip_code, to: :profile, allow_nil: true
  delegate :phone_number, to: :profile, prefix: true, allow_nil: true

  scope :avtive_ambassadors, -> (status) { where(role_id: ambassador_role_id, is_activated: status) }
  scope :ambassadors, -> { where(role_id: ambassador_role_id) }
  scope :sort_by_banned, -> { order(banned: :desc) }

  after_save :set_default_permissions

  BUYER_PERMISSIONS = [
                        { action_names: ['update_email', 'update_password', 'points', 'exchange_coins', 'generate_discount_code', 'add_user_info'], controller_name: 'users' },
                        { action_names: ['index'], controller_name: 'referral_sales' },
                        { action_names: ['all_actions'], controller_name: 'profiles' },
                        { action_names: ['get_products_from_shopify', 'get_selected_products'], controller_name: 'products' },
                        { action_names: ['add_partner_information'], controller_name: 'partner_informations' },
                        { action_names: ['my_orders'], controller_name: 'orders' },
                        { action_names: ['index', 'update_user_role', 'change_profile_picture', 'get_user_object', 'step_one', 'step_two', 'step_three', 'buyerDashboard', 'share_with_friends', 'acc_settings', 'take_snapshot'],
                          controller_name: 'dashboard' },
                        { action_names: ['add_comment', 'comment_like_unlike'], controller_name: 'comments' }
                      ]
  AMBASSADOR_PERMISSIONS = [
                            { action_names: ['update_email', 'update_password', 'points', 'exchange_coins', 'generate_discount_code', 'add_user_info'], controller_name: 'users' },
                            { action_names: ['index'], controller_name: 'referral_sales' },
                            { action_names: ['index'], controller_name: 'profiles' },
                            { action_names: ['get_products_from_shopify', 'get_selected_products'], controller_name: 'products' },
                            { action_names: ['my_orders'], controller_name: 'orders' },
                            { action_names: ['index', 'update_user_role', 'change_profile_picture', 'get_user_object', 'step_one', 'step_two', 'step_three', 'acc_settings', 'share_with_friends', 'take_snapshot'],
                              controller_name: 'dashboard' },
                            { action_names: ['add_comment', 'comment_like_unlike'], controller_name: 'comments' }
                          ]

  class << self
    def ambassador_role_id
      Role.find_by_name("Brand ambassador").id
    end

    def search_ambassadors params
      if params[:search].present?
        users =  User.joins(:profile).where("users.role_id = #{ambassador_role_id} and (LOWER(users.name) LIKE '%#{params[:search].downcase}%' OR LOWER(users.email) LIKE '%#{params[:search].downcase}%' OR LOWER(profiles.phone_number) LIKE '%#{params[:search]}%'
                                            OR LOWER(profiles.first_name) LIKE '%#{params[:search].downcase}%' OR LOWER(profiles.surname) LIKE '%#{params[:search].downcase}%')")
      else
        users = params[:active].present? && params[:active] != "All" ? User.avtive_ambassadors(params[:active]) : User.ambassadors
      end
      users.order(created_at: :desc)
    end

    def brand_ambassadors
      user_with_payment = Payment.pluck(:user_id)
      User.joins(:role).where("roles.name = 'Brand ambassador'").where(id: user_with_payment)
    end

    def ambassadors_with_sales
      user_with_sales = ReferralSale.pluck(:user_id)
      User.joins(:role).where("roles.name = 'Brand ambassador'").where(id: user_with_sales)
    end

    def search_users q
      filter_users(q).sort_by_banned
    end

    def filter_users q
      q = q.downcase
      joins(:profile).where("LOWER(users.name) LIKE '%#{q}%' OR LOWER(users.email) LIKE '%#{q}%' OR LOWER(profiles.phone_number) LIKE '%#{q}%'")
    end

    def all_users params
      return User.search_users(params[:q]) if params[:q].present?
      return User.all if params[:deduct_points].present?
      User.sort_by_banned if params[:q].blank? && params[:deduct_points].blank?
    end

    def users_with_points
      users_with_points = []
      users = User.includes(:points).all
      users.each do |user|
        users_with_points << user.id if user.total_points > 0
      end
      User.where(id: users_with_points)
    end
  end

  def add_new_permissions permissions
    permissions.each do |key, permission|
      self.permissions.find_or_create_by(action_name: permission[:action], controller_name: permission[:controller])
    end
  end

  def delete_old_permissions permissions
    permissions.each do |key, permission|
      permission = self.permissions.find_by(action_name: permission[:action], controller_name: permission[:controller])
      permission.delete if permission.present?
    end
  end

  def set_default_permissions
    return if role.blank? || permissions.present?
    create_permissions(User::BUYER_PERMISSIONS) if self.is_buyer?
    create_permissions(User::AMBASSADOR_PERMISSIONS) if self.is_ambassador?
  end

  def create_permissions permissions
    permissions.each do |permission|
      permission[:action_names].each do |action|
        self.permissions.find_or_create_by(action_name: action, controller_name: permission[:controller_name])
      end
    end
  end

  def exceed_blogs_limit? ## Limit set to 10
    self.blogs.where('CAST(created_at AS DATE) = ?', DateTime.now.strftime("%Y-%m-%d")).count >= 10
  end

  def is_admin?
    return true if(self.role.name.eql?("Admin") unless self.role.nil?)
  end

  def is_buyer?
    return false if role.blank?
    role.name == "Buyer"
  end

  def is_ambassador?
    return true if(self.role.name.eql?("Brand ambassador") unless self.role.nil?)
  end

  def is_buyer?
    return true if(self.role.name.eql?("Buyer") unless self.role.nil?)
  end

  def users_blog? blog_id
    blogs.find_by(id: blog_id).present?
  end

  def filtered_blogs(sort_type, category, title="")
    sort_by = sort_type.present? ? sort_type : 0
    category = category.present? ? category : Category.ids
    blogs = self.is_admin? ? filter_by_category(category) : filter_by_category(category).published_and_drafted_blogs(self.id)
    title.present? ? blogs.search_by_title(title).sort_blogs(sort_by) : blogs.sort_blogs(sort_by)
  end

  def filter_by_category(category)
    Blog.eager_load_objects.filter_by_category(category)
  end

  def full_name
    [first_name, surname].join(' ')
  end

  def last_four_points
    points.order(created_at: :desc).first(4)
  end

  def total_points
    points.present? ? points.sum(:point_value) : 0
  end

  def has_permission? action, controller
    permissions.where(action_name: action, controller_name: controller).present?
  end

  def update_total_income(price, order_no)
    user_commission  = commission.present? ? commission.to_f : 8.0
    old_income = self.total_income
    self.update_attributes(total_income: total_income.to_f + (price.to_f * user_commission/100))
    commission_history = self.commission_histories.find_or_create_by(order_no: order_no, old_income: old_income, new_income: self.total_income)
    self.notifications.find_or_create_by(source: commission_history)
  end

  def already_shared_blog?(blog_id, url_type)
    share_urls.find_by(blog_id: blog_id, url_type: url_type).present?
  end

  def blog_sharing_limit_exceed?(url_type)
    share_urls.where(url_type: url_type, created_at: DateTime.now.all_day).count >= 10
  end

  def joined_group?(group_id)
    joined_groups.find_by(group_id: group_id).present?
  end
end
