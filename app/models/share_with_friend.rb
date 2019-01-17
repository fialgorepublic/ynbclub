# == Schema Information
#
# Table name: share_with_friends
#
#  id               :bigint(8)        not null, primary key
#  reward_text      :string
#  earn_coins_text  :string
#  fb_btn_text      :string
#  twitter_btn_text :string
#  email_btn_text   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ShareWithFriend < ApplicationRecord
end
