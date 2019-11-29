class Conversation < ApplicationRecord
  self.per_page = 10
  default_scope { order(updated_at: :desc) }

  belongs_to :group, counter_cache: true, touch: true
  belongs_to :user,  counter_cache: true

  has_many   :replies, class_name: 'Conversation', foreign_key: 'parent_id'
  has_many   :conversation_likes

  validates :body, presence: true

  scope :post_conversations,  ->             { where(parent_id: nil) }
  scope :filter_by_subject,   -> (subject)   { where('lower(subject) like ?', "%#{subject&.downcase}%") }
  scope :popular_first,       ->             { reorder(likes_count: :desc, replies_count: :desc) }
  scope :unanswered,          ->             { reorder(replies_count: 0) }
  scope :a_z,                 ->             { reorder(subject: :asc) }
  scope :liked_conversations, -> (user_id)   { joins(:conversation_likes).where(conversation_likes: { user_id: user_id }) }
  scope :sort_by_title,       -> (type)      { reorder(subject: type ? type : :asc) }
  scope :sort_by_type,        -> (sort_type) do
    sort_type = sort_type.to_i
    case sort_type
    when 2
      popular_first
    when 3
      a_z
    when 4
      unanswered
    end
  end

  before_save  :format_tags
  after_create :update_replies_count

  delegate :avatar, to: :user, prefix: true

  def parent
    Conversation.find_by(id: self.parent_id)
  end

  def three_related_posts
    Conversation.post_conversations.filter_by_subject(self.subject).first(3)
  end

  def conversation_like_exists?(user_id)
    conversation_likes.find_by(user_id: user_id).present?
  end

  private
    def format_tags
      self.tags = self.tags.map!{|tag| tag.split(',')}.flatten
    end

    def update_replies_count
      return if self.parent_id.blank?
      self.parent.increment!(:replies_count)
      self.parent.touch
    end
end
