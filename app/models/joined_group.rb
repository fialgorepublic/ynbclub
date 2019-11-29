class JoinedGroup < ApplicationRecord
  belongs_to :group, counter_cache: :users_count, touch: true
  belongs_to :user, counter_cache:  :groups_count
end
