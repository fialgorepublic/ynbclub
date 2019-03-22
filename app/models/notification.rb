class Notification < ApplicationRecord
  self.per_page = 100

  belongs_to :source, polymorphic: true
  belongs_to :target, class_name: 'User', optional: true
end
