class ShareUrl < ApplicationRecord
  belongs_to :user
  belongs_to :blog, optional: true

  delegate :title, to: :blog, prefix: true
end
