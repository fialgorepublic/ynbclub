class City < ApplicationRecord
  belongs_to :state, optional: true

  has_many :districts
  has_many :provinces
end
