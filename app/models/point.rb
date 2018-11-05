class Point < ApplicationRecord
  belongs_to :point_type
  belongs_to :user

  delegate :name, to: :point_type
end
