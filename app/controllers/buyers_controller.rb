class BuyersController < ApplicationController
  before_action :authenticate_user!

  def buyer_orders
    initiate_shopify_session
    customer_id = get_customer_id
    @orders = ShopifyAPI::Order.find(:all, :params => {:status => "closed",customer_id: customer_id ,:limit => 250})
    puts "---------------------------------------",@orders.inspect
    clear_shopify_session
  end

  private

  def get_customer_id
    customer = Customer.where(email: current_user.email).first
    if customer.present?
      customer_id = customer.customer_id
    else
      customer_id = nil
    end
  end

end
