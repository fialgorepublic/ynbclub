class Conversation < ApplicationRecord
  default_scope { order(updated_at: :desc) }

  belongs_to :group, counter_cache: true
  belongs_to :user,  counter_cache: true

  has_many   :replies, class_name: 'Conversation',  foreign_key: 'parent_id'

  validates :body, presence: true

  scope :post_conversations, -> { where(parent_id: nil) }

  before_save :format_tags

  private
    def format_tags
      self.tags = self.tags.map!{|tag| tag.split(',')}.flatten
    end
end
