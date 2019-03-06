class Order < ApplicationRecord
  belongs_to :city,     optional: true
  belongs_to :district, optional: true
  belongs_to :province, optional: true
  belongs_to :ward,     optional: true

  has_many :items

  accepts_nested_attributes_for :items

  delegate :name, :id, to :city,     prefix: true
  delegate :name, :id, to :district, prefix: true
  delegate :name, :id, to :province, prefix: true
  delegate :name, :id, to :ward,     prefix: true

  scope :user_orders, -> (email) { where(email: email) }
end
