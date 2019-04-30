# == Schema Information
#
# Table name: snapshots
#
#  id                        :bigint(8)        not null, primary key
#  step1_avatar_file_name    :string
#  step1_avatar_content_type :string
#  step1_avatar_file_size    :integer
#  step1_avatar_updated_at   :datetime
#  step2_avatar_file_name    :string
#  step2_avatar_content_type :string
#  step2_avatar_file_size    :integer
#  step2_avatar_updated_at   :datetime
#  step3_avatar_file_name    :string
#  step3_avatar_content_type :string
#  step3_avatar_file_size    :integer
#  step3_avatar_updated_at   :datetime
#  step4_avatar_file_name    :string
#  step4_avatar_content_type :string
#  step4_avatar_file_size    :integer
#  step4_avatar_updated_at   :datetime
#  step1_text                :string
#  step2_text                :string
#  step3_text                :string
#  step4_text                :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Snapshot < ApplicationRecord
  has_one_attached :step1_avatar
  has_one_attached :step2_avatar
  has_one_attached :step3_avatar
  has_one_attached :step4_avatar

  def delete_avatar?(id)
    return step1_avatar.destroy if id == "step1"
    return step2_avatar.destroy if id == "step2"
    return step3_avatar.destroy if id == "step3"
    step4_avatar.destroy if id == "step4"
  end
end
