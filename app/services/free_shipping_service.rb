class FreeShippingService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    create_discount_code
  end

  private

    def create_discount_code
      user_name = user.name.presence || user.full_name.presence || 'ambassador'
      customer_id = find_or_create_shopify_customer
      if customer_id.present?
        begin
          price_rule = ShopifyAPI::PriceRule.create(
                        title: user_name,
                        target_type: "shipping_line",
                        target_selection: "all",
                        allocation_method: "each",
                        value_type: "percentage",
                        value: -100.0,
                        once_per_customer: true,
                        customer_selection: "prerequisite",
                        prerequisite_customer_ids: [customer_id],
                        starts_at: DateTime.now
                      )
          discount_code = ShopifyAPI::DiscountCode.create(price_rule_id: price_rule.id, discount_code: { code: user.reference_no} )
          UserMailer.send_discount_code(user).deliver_later
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
        customer = ShopifyAPI::Customer.create({ first_name: user.name, email: user.email});
        customer.id
      rescue => ex
        nil
      end
    end
end
