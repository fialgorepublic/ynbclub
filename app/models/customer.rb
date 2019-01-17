# == Schema Information
#
# Table name: customers
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  email       :string           default("")
#  customer_id :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Customer < ApplicationRecord
  validates :customer_id, uniqueness: true
end
