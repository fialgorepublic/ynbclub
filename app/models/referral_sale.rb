class ReferralSale < ApplicationRecord
  self.per_page = 10

  belongs_to :user
  after_save :set_ambassador_value

  private
  def set_ambassador_value
    if (self.is_approved == true)
      user = self.user
      total_income = user.total_income
      user.update_attributes(total_income: total_income.to_f + self.price.to_f)
    end
  end
end
