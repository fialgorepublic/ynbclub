class User < ApplicationRecord
  self.per_page = 10
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :referral, uniqueness: true
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

  def is_admin?
    return true if(self.role.name.eql?("Admin") unless self.role.nil?)
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

  def filtered_blogs
    self.is_admin? ? Blog.all.order(is_published: :DESC) : published_and_drafted_blogs
  end

  def published_and_drafted_blogs
    published_blogs = Blog.where(is_published: true)
    draft_blogs = Blog.where(is_published: false, user_id: self.id)
    published_blogs.or(draft_blogs).order('created_at ASC')
  end
end
