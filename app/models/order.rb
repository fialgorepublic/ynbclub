class Order < ApplicationRecord
  belongs_to :city,     optional: true
  belongs_to :district, optional: true
  belongs_to :province, optional: true
  belongs_to :ward,     optional: true

  has_many :items

  accepts_nested_attributes_for :items

  scope :user_orders, -> (email) { where(email: email) }
end
