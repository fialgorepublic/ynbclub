# == Schema Information
#
# Table name: profiles
#
#  id              :bigint(8)        not null, primary key
#  phone_number    :string
#  first_name      :string
#  surname         :string
#  gender          :string
#  date_of_birth   :date
#  address_line_1  :string
#  address_line_2  :string
#  state           :string
#  city            :string
#  zip_code        :string
#  user_id         :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  security_number :string
#  account_number  :string
#  acc_holder_name :string
#  bank_name       :string
#

class Profile < ApplicationRecord
  belongs_to :user
  validates :bank_name, presence: true, format: { with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/,
    message: "only allows letters" }
  validates :account_number, presence: true,  :numericality => { :greater_than_or_equal_to => 0 }, uniqueness: true
  validates :acc_holder_name, presence: true, format: { with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/,
    message: "only allows letters" } 
end
