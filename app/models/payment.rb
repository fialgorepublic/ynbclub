# == Schema Information
#
# Table name: payments
#
#  id             :bigint(8)        not null, primary key
#  payment_code   :integer
#  payment_date   :date
#  amount         :float
#  recipient_name :string
#  email          :string
#  number_math    :string
#  status         :string
#  note           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#

class Payment < ApplicationRecord
  self.per_page = 10
  belongs_to :user

  validate :valid_amount, on: :create
  after_create :deduct_user_amount

  private
    def valid_amount
      errors.add(:amount, "Entered amount exceeds user's total income.") if amount > user.total_income
      errors.add(:amount, 'Amount must be greater than zero.') if amount <= 0
    end

    def deduct_user_amount
      user.update_attributes(total_income: user.total_income.to_f - amount.to_f, paid: self.amount + user.paid.to_f)
    end
end
