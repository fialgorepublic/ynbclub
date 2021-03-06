class Group < ApplicationRecord
  extend FriendlyId
  friendly_id do |config|
    config.base = :name
    config.use :slugged
    config.use Module.new {
      def normalize_friendly_id(text)
        text.to_slug.normalize! :transliterations => [:vietnamese]
      end
    }
  end

  default_scope { order(updated_at: :desc) }

  belongs_to :group_category
  belongs_to :admin_group, class_name: "User", foreign_key: "user_id"

  has_many :joined_groups
  has_many :users, through: :joined_groups
  has_many :conversations

  has_one_attached :logo

  validates :name, :description, :group_category_id, presence: true
  validates :logo, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  scope :sort_by_title, -> (sort_type)  do
    sort_type = sort_type.present? ? sort_type : 0
    sort_type == 0 ? all : reorder("lower(name) #{sort_type}")
  end
  scope :filter_by_categories, -> (categroy_ids) { where(group_category_id: categroy_ids.split(',')) }
  scope :filter_by_name, -> (name) { where('lower(name) like ?', "%#{name&.downcase}%") }

  def post_conversations
    conversations.post_conversations
  end
end
