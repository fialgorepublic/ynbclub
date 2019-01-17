# == Schema Information
#
# Table name: point_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  point        :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_deleted   :boolean          default(FALSE)
#  earn_coin_id :bigint(8)
#

class PointType < ApplicationRecord
  belongs_to :earn_coin
  has_many :points

  before_create :set_id

  def set_id
    max_id = PointType.maximum(:id)
    self.id = max_id.present? ? max_id + 1 : 1
  end
end
