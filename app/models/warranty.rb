class Warranty < ApplicationRecord
  belongs_to :item, optional: true
  scope :get_warranties, -> (number) {where("number LIKE ? AND assigned = ?", "#{number}%", false)}
end
