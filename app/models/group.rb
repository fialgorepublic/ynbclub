class Group < ApplicationRecord
  extend FriendlyId
  friendly_id do |config|
    config.base = :name
    config.use :slugged
    config.use Module.new {
      def normalize_friendly_id(text)
        text.to_slug.normalize! :transliterations => [:vietnamese]
      end
    }
  end

  has_one_attached :logo

  validates :name, :description, presence: true
  validates :logo, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  scope :sort_by_latest, -> { order(updated_at: :desc ) }
  scope :sort_by_title, -> (sort_type)  do
    sort_type = sort_type.present? ? sort_type : 0
    sort_type == 0 ? sort_by_latest : reorder(name: sort_type.to_sym)
  end
end
