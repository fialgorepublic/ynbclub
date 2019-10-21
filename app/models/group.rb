class Group < ApplicationRecord
  has_one_attached :logo

  validates :name, :description, presence: true
  validates :logo, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
end
