class Customer < ApplicationRecord
  validates :customer_id, uniqueness: true
end
