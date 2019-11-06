class Conversation < ApplicationRecord
  belongs_to :group, counter_cache: true
  belongs_to :user,  counter_cache: true

  has_many   :replies, class_name: 'Conversation',  foreign_key: 'parent_id'
end
