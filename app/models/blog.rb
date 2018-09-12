class Blog < ApplicationRecord
  belongs_to :category
  has_many :comments
  has_many :likes
  has_many :products, :dependent => :destroy
  has_many :blog_views, :dependent => :destroy
  has_attached_file :avatar,
                    :default_url => "/images/:style/missing.png",
                    :storage => :s3,
                    :url => 's3_domain_url',
                    :s3_host_alias => 'saintalgorepublic.s3-website-us-east-1.amazonaws.com',
                    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
                    :path => "/files/:style/:id_:filename",
                    styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def add_products(product)
    if product[:product_id].present?
      product[:product_id].each_with_index do |value, index|
        Product.create(product_id: value, title: product[:title][index], price: product[:price][index],
                       blog_id: self.id, avatar: product[:avatar][index])
      end
    end
    # products = Product.where("id IN (?)", product_ids)
    # if products.any?
    #   products.each do |product|
    #     self.products << product
    #   end
    # end
  end

  def update_products(product)
    self.products.delete_all
    if product[:product_id].present?
      product[:product_id].each_with_index do |value, index|
        Product.create(product_id: value, title: product[:title][index], price: product[:price][index],
                       blog_id: self.id, avatar: product[:avatar][index])
      end
    end

  end
end
