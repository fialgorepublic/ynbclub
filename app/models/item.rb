class Item < ApplicationRecord
  belongs_to :order
  has_one :product_warranty
  validates :name, uniqueness: { scope:  :order_id }
end
