class ShopifyService
  attr_reader :user, :coins_to_exchange, :defined_coins, :eqivalent_to

  def initialize(user, coins)
    @user = user
    @coins_to_exchange = coins.to_f
    @defined_coins = 0
    @eqivalent_to = 0
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
      user_name = user.name if user.name
      user_name = user.full_name if user.full_name.present?
      user_name = 'ambassador' if user.name.blank? && user.full_name.blank?
      customer_id = find_or_create_shopify_customer
      reward = calculate_rewarded_amount

      if customer_id.present?
        begin
          price_rule = ShopifyAPI::PriceRule.create(
                        title: user_name,
                        target_type: "line_item",
                        target_selection: "all",
                        allocation_method: "across",
                        value_type: "fixed_amount",
                        value: -1 * reward,
                        once_per_customer: true,
                        customer_selection: "prerequisite",
                        prerequisite_customer_ids: [customer_id],
                        starts_at: DateTime.now
                      )
          discount_code = ShopifyAPI::DiscountCode.create(price_rule_id: price_rule.id, discount_code: { code: (0...10).map { ('a'..'z').to_a[rand(26)] }.join} )
          user.exchange_histories.create(discount_code: discount_code.code, exchanged_coins: coins_to_exchange, rewarded_amount: reward)
          user.points.create(point_value: (-1 * coins_to_exchange), invitee: "Exchanged #{coins_to_exchange.to_i} coins for discount code.")
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
      eqivalent_to  = filter_the_amount(EarnCoin.first.price)
      exhange_rate = eqivalent_to.to_f / defined_coins.to_f
      exhange_rate * coins_to_exchange
    end

    def filter_the_amount(price)
      price.remove('₫').split(',').join('')
    end
end
