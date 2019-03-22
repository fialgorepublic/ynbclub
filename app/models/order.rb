class Order < ApplicationRecord
  self.per_page = 200
  default_scope { order(order_id: :desc) }

  belongs_to :city,     optional: true
  belongs_to :district, optional: true
  belongs_to :province, optional: true
  belongs_to :ward,     optional: true

  has_many :items
  has_many :notifications, as: :source

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

  after_save :update_commission, if: :status_updated?

  private
    def update_commission
      return if ghtk_status != 'Controled'
      referral_sale = ReferralSale.find_by(order_id: self.order_id)

      return if referral_sale.blank?
      user = referral_sale.user
      user.update_total_income(referral_sale.price)
    end

    def status_updated?
      ghtk_status_changed?
    end
end
