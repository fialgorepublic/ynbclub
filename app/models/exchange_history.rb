class ExchangeHistory < ApplicationRecord
  self.per_page = 10
  belongs_to :user
end
