# == Schema Information
#
# Table name: earn_coins
#
#  id             :bigint(8)        not null, primary key
#  main_text      :string
#  how_earn_text  :string
#  how_spend_text :string
#  earn_way       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  coins          :string
#  price          :string
#

class EarnCoin < ApplicationRecord
  has_many :point_types

  accepts_nested_attributes_for :point_types, reject_if: :all_blank, allow_destroy: true
end
