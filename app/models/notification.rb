class Notification < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, class_name: 'User', optional: true

  delegate :old_income, :new_income, :order_no, :ghtk_status, to: :source, prefix: true
end
