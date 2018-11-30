class EarnCoin < ApplicationRecord
  has_many :point_types

  accepts_nested_attributes_for :point_types
end
