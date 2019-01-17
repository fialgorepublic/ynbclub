# == Schema Information
#
# Table name: settings
#
#  id          :bigint(8)        not null, primary key
#  min_payment :float
#  cookie_time :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Setting < ApplicationRecord
end
