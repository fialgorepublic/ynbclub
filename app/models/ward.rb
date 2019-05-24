class Ward < ApplicationRecord
  belongs_to :district, optional: true
end
