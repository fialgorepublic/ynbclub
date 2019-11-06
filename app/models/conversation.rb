class Conversation < ApplicationRecord
  belongs_to :group, counter_cache: true
  belongs_to :user,  counter_cache: true
end
