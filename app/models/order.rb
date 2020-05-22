class Order < ApplicationRecord
  self.per_page = 200
  default_scope { order(id: :desc) }

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
    'Call Day 1'  => 2,
    'Call Day 2'  => 3,
    'Đã nhắn tin'  => 4,
    'No'  => 5
  }

  enum transport_type: {
    truck: 1,
    fly:   2
  }

  after_save   :update_commission, if: :status_updated?

  private
    def update_commission
      referral_sale = ReferralSale.find_by(order_id: self.order_id)
      user =  referral_sale.blank? ? User.find_by(role: Role.find_by_name('Admin')) : referral_sale.user
      self.notifications.find_or_create_by(target: user)

      return if referral_sale.blank?
      return if ghtk_status != 'Controled'
      user = referral_sale.user
      user.update_total_income(referral_sale.price, self.order_name)
    end

    def status_updated?
      saved_change_to_ghtk_status?
    end

end
