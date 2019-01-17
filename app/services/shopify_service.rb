class ShopifyService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    create_discount_code
  end

  def self.create_session
    session = ShopifyAPI::Session.new("saintlbeau.myshopify.com", "65f08aa2bc5386c55298ed566ad18ccd")
    ShopifyAPI::Base.activate_session(session)
  end

  # def self.get_all_products
  #   ShopifyAPI::Product.all.map{|product| [product.title, product.id]}
  # end

  # def self.get_products(ids)
  #   ShopifyAPI::Product.find(:all, params: { ids: ids })
  # end

  # def delete_offer_price_rule
  #   delete_price_rule
  # end

  private

    def create_discount_code
      user_name = user.name if user.name
      user_name = user.full_name if user.full_name.present?
      user_name = 'ambassador' if user.name.blank? && user.full_name.blank?

      begin
        price_rule = ShopifyAPI::PriceRule.create(
                      title: user_name,
                      target_type: "shipping_line",
                      target_selection: "all",
                      allocation_method: "across",
                      value_type: "percentage",
                      value: "-20",
                      customer_selection: "all",
                      starts_at: DateTime.now
                    )
        discount_code = ShopifyAPI::DiscountCode.create(price_rule_id: price_rule.id, discount_code: { code: (0...10).map { ('a'..'z').to_a[rand(26)] }.join} )
        user.update(discount_code: discount_code.code, price_rule_id: price_rule.id)
        [true, "Discount code is created Successfully!"]
      rescue => ex
        [false, ex.message]
      end
    end

    # def delete_price_rule
    #   return unless offer.price_rule_id.present?
    #   ShopifyAPI::PriceRule.delete(offer.price_rule_id)
    # end
end
