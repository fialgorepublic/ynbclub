class ExchangeHistory < ApplicationRecord
  self.per_page = 10
  default_scope { order(id: :desc) }

  belongs_to :user
end
