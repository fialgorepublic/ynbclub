class Notification < ApplicationRecord
  self.per_page = 100

  default_scope { order(created_at: :desc) }

  belongs_to :source, polymorphic: true
  belongs_to :target, class_name: 'User', optional: true

  scope :filter_by_source_type, -> (type)      { where(source_type: type) }
  scope :filter_by_target,      -> (target_id) { where(target_id: target_id) }
end
