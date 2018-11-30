class PointType < ApplicationRecord
  belongs_to :earn_coin
  has_many :points
end
