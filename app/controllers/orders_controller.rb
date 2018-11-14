class OrdersController < ApplicationController
    before_action :authenticate_user!

  def my_orders
    initiate_shopify_session
    if current_user.is_admin?
      @orders = ShopifyAPI::Order.all
    else
      customer_id = get_customer_id
      @orders = customer_id.present? ? ShopifyAPI::Order.find(:all, :params => {:status => "any",customer_id: customer_id ,:limit => 250}) : []
    end
    clear_shopify_session
  end

  private
    def get_customer_id
      customer = Customer.find_by(email: current_user.email)
      customer.present? ? customer.customer_id : nil
    end
end
