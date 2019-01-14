class Point < ApplicationRecord
  belongs_to :point_type, optional: true
  belongs_to :user

  delegate :name, to: :point_type
end
