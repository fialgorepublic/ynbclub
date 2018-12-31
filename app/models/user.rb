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
  end

  # after_create :generate_profile
  # after_update :update_profile_names

  # def update_profile_names
  #   unless profile.blank?
  #     first_name = nil
  #     surname = nil
  #     if self.name.present?
  #       name = self.name.split(" ")
  #       first_name = name[0]
  #       surname = name[1]
  #     end
  #     profile.update(first_name: first_name, surname: surname)
  #   end
  # end

  # def generate_profile
  #   first_name = nil
  #   surname = nil
  #   if self.name.present?
  #     name = self.name.split(" ")
  #     first_name = name[0]
  #     surname = name[1]
  #   end
  #   self.create_profile(phone_number: phone_number, first_name: first_name, surname: surname)
  # end

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
end
