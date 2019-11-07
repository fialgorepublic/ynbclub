class Conversation < ApplicationRecord
  default_scope { order(updated_at: :desc) }

  belongs_to :group, counter_cache: true
  belongs_to :user,  counter_cache: true

  has_many   :replies, class_name: 'Conversation',  foreign_key: 'parent_id'

  scope :post_conversations, -> { where(parent_id: nil) }
end
