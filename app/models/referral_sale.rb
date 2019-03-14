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

  belongs_to :user
  #after_save :set_ambassador_value

  private
    def set_ambassador_value
      user.update_attributes(total_income: total_income) if is_approved?
    end

    def total_income
      user_commission = user.commission.present? ? user.commission.to_f : 8.0
      user.total_income.to_f + (price.to_f * user_commission/100)
    end
end
