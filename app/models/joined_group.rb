class JoinedGroup < ApplicationRecord
  belongs_to :group, counter_cache: :users_count
  belongs_to :user, counter_cache:  :groups_count
end