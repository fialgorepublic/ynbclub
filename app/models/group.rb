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

  default_scope { order(updated_at: :desc) }

  has_one_attached :logo

  validates :name, :description, presence: true
  validates :logo, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
end
