class EarnCoin < ApplicationRecord
  has_many :point_types

  accept_nested_ttributes :point_types
end
