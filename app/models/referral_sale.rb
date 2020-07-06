# == Schema Information
#
# Table name: referral_sales
#
#  id          :bigint(8)        not null, primary key
#  user_id     :integer
#  order_id    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  email       :string
#  address     :text
#  shopdomain  :string
#  price       :string
#  is_approved :boolean          default(FALSE)
#  order_no    :string
#  ghtk_status :integer
#

class ReferralSale < ApplicationRecord
  self.per_page = 100
  default_scope { order(id: :desc) }

  belongs_to :user
  #after_save :set_ambassador_value
  scope :date_filter_with_users, -> (start_date, end_date, user_id) { where("referral_sales.created_at >= ? AND referral_sales.created_at <= ? AND user_id = ?", start_date, end_date, user_id ) }
  scope :date_filter, -> (date_range) {where(created_at: date_range)}
  scope :for_orders, -> (orders) {where(order_id: orders)}
  delegate :commission, :name, to: :user, prefix: true, allow_nil: true

  def tracking_id
    order =  Order.find_by(order_id: self.order_id)
    return '--' if order.blank?
    order.tracking_link
  end

  def discount_is_not_paid?
    order =  Order.find_by(order_id: self.order_id)
    return true if order.blank?
    order.ghtk_status == 'Controled' ? false : true
  end

  private
    def set_ambassador_value
      user.update_attributes(total_income: total_income) if is_approved?
    end

    def total_income
      user_commission = user.commission.present? ? user.commission.to_f : 8.0
      user.total_income.to_f + (price.to_f * user_commission/100)
    end
end
