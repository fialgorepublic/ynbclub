class Conversation < ApplicationRecord
  default_scope { order(updated_at: :desc) }

  belongs_to :group, counter_cache: true
  belongs_to :user,  counter_cache: true

  has_many   :replies, class_name: 'Conversation', foreign_key: 'parent_id'

  validates :body, presence: true

  scope :post_conversations, -> { where(parent_id: nil) }

  before_save  :format_tags
  after_create :update_replies_count

  def parent
    Conversation.find_by(id: self.parent_id)
  end

  private
    def format_tags
      self.tags = self.tags.map!{|tag| tag.split(',')}.flatten
    end

    def update_replies_count
      self.parent.update(replies_count: replies_count + 1) if self.parent_id.present?
    end
end
