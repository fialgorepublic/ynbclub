# == Schema Information
#
# Table name: points
#
#  id            :bigint(8)        not null, primary key
#  user_id       :integer
#  point_type_id :integer
#  point_value   :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invitee       :string
#  share_url_id  :integer
#  order_id      :string
#

class Point < ApplicationRecord
  belongs_to :point_type, optional: true
  belongs_to :user

  delegate :name, to: :point_type, allow_nil: true
end
