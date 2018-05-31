class Point < ApplicationRecord
  belongs_to :point_type
  belongs_to :user
end
