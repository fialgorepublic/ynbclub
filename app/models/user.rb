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
  self.per_page = 10
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
  has_many :blog_views
  has_many :blogs
  has_many :exchange_histories
  has_many :permissions
  has_attached_file :avatar,
                    :default_url => "/images/:style/missing.png",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename",
                    styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

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
      q = q.downcase
      joins(:profile).where("LOWER(users.name) LIKE '%#{q}%' OR LOWER(users.email) LIKE '%#{q}%' OR LOWER(profiles.phone_number) LIKE '%#{q}%'").sort_by_banned
    end

    def all_users params
      return User.search_users(params[:q]) if params[:q].present?
      return User.all if params[:deduct_points].present?
      User.sort_by_banned if params[:q].blank? && params[:deduct_points].blank?
    end
  end

  def set_default_permissions
    return if role.blank? || permissions.present?
    create_permissions(User::BUYER_PERMISSIONS) if self.is_buyer?
    create_permissions(User::AMBASSADOR_PERMISSIONS) if self.is_ambassador?
  end

  def create_permissions permissions
    permissions.each do |permission|
      self.permissions.create(action_name: permission[:action_names], controller_name: permission[:controller_name])
    end
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

  def filtered_blogs(sort_type)
    sort_by = sort_type.present? ? sort_type : 0
    self.is_admin? ? Blog.sort_blogs(sort_by) : Blog.published_and_drafted_blogs(self.id).sort_blogs(sort_by)
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
end
