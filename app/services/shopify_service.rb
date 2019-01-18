class ShopifyService
  attr_reader :user, :coins_to_exchange

  def initialize(user, coins)
    @user = user
    @coins_to_exchange = coins
  end

  def call
    create_discount_code
  end

  def self.create_session
    session = ShopifyAPI::Session.new("saintlbeau.myshopify.com", "b8a6f6c3187c79cd975c9bde50c12756")
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
      convert_to_dollars

      user_name = user.name if user.name
      user_name = user.full_name if user.full_name.present?
      user_name = 'ambassador' if user.name.blank? && user.full_name.blank?
      customer_id = find_or_create_shopify_customer

      if customer_id.present?
        begin
          price_rule = ShopifyAPI::PriceRule.create(
                        title: user_name,
                        target_type: "line_item",
                        target_selection: "all",
                        allocation_method: "across",
                        value_type: "fixed_amount",
                        value: calculate_rewarded_amount,
                        once_per_customer: true,
                        customer_selection: "prerequisite",
                        prerequisite_customer_ids: [customer_id],
                        starts_at: DateTime.now
                      )
          discount_code = ShopifyAPI::DiscountCode.create(price_rule_id: price_rule.id, discount_code: { code: (0...10).map { ('a'..'z').to_a[rand(26)] }.join} )
          user.update(discount_code: discount_code.code)
          [true, "Discount code is created Successfully!"]
        rescue => ex
          [false, ex.message]
        end
      else
        [false, "Unable to create customer."]
      end
    end

    # def delete_price_rule
    #   return unless offer.price_rule_id.present?
    #   ShopifyAPI::PriceRule.delete(offer.price_rule_id)
    # end

    def find_or_create_shopify_customer
      begin
        customer = ShopifyAPI::Customer.search(query:"email:#{user.email}")
        return customer.first.id if customer.present?

        customer = ShopifyAPI::Customer.create({ first_name: user.first_name, last_name: user.last_name.present? ? user.last_name : "user", email: user.email});
        customer.first.id if customer.present?
      rescue => ex
        nil
      end
    end

    def calculate_rewarded_amount
      #get admin decided excange_rate
      defined_coins = EarnCoin.first.coins
      eqivalent_to  = EarnCoin.first.price
      exhange_rate = eqivalent_to.to_f / defined_coins.to_f
      -1 * (exhange_rate * coins_to_exchange)
    end
end
