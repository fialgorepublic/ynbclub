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
  default_scope { order(order_no: :desc) }

  belongs_to :user
  #after_save :set_ambassador_value

  delegate :commission, :name, to: :user, prefix: true, allow_nil: true

  def order_ghtk_status
    order =  Order.find_by(order_id: self.order_id)
    return 'GHTK Order Not Found' if order.blank?
    order.ghtk_status.present? ? order.ghtk_status : 'Status not updated yet.'
  end

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
