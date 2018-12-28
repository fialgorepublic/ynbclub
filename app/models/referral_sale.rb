class ReferralSale < ApplicationRecord
  self.per_page = 10

  belongs_to :user
  after_save :set_ambassador_value

  private
    def set_ambassador_value
      user.update_attributes(total_income: user.total_income.to_f + price.to_f) if is_approved?
    end
end
