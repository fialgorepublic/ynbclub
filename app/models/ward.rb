class Ward < ApplicationRecord
  belongs_to :district, optional: true
  belongs_to :province, optional: true
end
