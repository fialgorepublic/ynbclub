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
  belongs_to :user
end
