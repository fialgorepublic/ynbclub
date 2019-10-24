class GroupCategory < ApplicationRecord
  has_many :groups

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
