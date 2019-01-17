# == Schema Information
#
# Table name: partner_informations
#
#  id             :bigint(8)        not null, primary key
#  store_name     :string
#  phone_no       :string
#  address        :text
#  id_number      :string
#  bank_name      :string
#  account_number :string
#  account_name   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PartnerInformation < ApplicationRecord
end
