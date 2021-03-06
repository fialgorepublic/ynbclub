
class ConversationLike < ApplicationRecord
  belongs_to :user,         counter_cache: :likes_count
  belongs_to :conversation, counter_cache: :likes_count, touch: true
end
