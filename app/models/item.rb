class Item < ApplicationRecord
  belongs_to :order

  validates :name, uniqueness: { scope:  :order_id }
end
