class CommissionHistory < ApplicationRecord
  belongs_to :user
  has_many   :notifications, as: :source
end
