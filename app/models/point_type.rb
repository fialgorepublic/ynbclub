class PointType < ApplicationRecord
  belongs_to :earn_coin
  has_many :points

  before_create :set_id

  def set_id
    max_id = PointType.maximum(:id)
    self.id = max_id.present? ? max_id + 1 : 1
  end
end
