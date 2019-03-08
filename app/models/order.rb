class Order < ApplicationRecord
  self.per_page = 10
  default_scope { order(order_id: :desc) }

  belongs_to :city,     optional: true
  belongs_to :district, optional: true
  belongs_to :province, optional: true
  belongs_to :ward,     optional: true

  has_many :items

  accepts_nested_attributes_for :items

  delegate :name, :id, to: :city,     prefix: true, allow_nil: true
  delegate :name, :id, to: :district, prefix: true, allow_nil: true
  delegate :name, :id, to: :province, prefix: true, allow_nil: true
  delegate :name, :id, to: :ward,     prefix: true, allow_nil: true

  scope :user_orders, -> (email) { where(email: email) }

  enum picked_phone: {
    'N/A' => 0,
    'Yes' => 1,
    'No'  => 2
  }
end
