class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :authorize_user!, except: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  # def my_orders
  #   initiate_shopify_session
  #   if current_user.is_admin?
  #     @orders = get_all_orders
  #   else
  #     customer_id = get_customer_id
  #     @orders = customer_id.present? ? ShopifyAPI::Order.find(:all, :params => {:status => "any",customer_id: customer_id ,:limit => 250}) : []
  #   end
  #   clear_shopify_session
  # end

  def index
    @orders = current_user.is_admin? ? Order.all : Order.user_orders(current_user.email)
  end

  def create
    OrderService.new(params[:order]).create_order
  end

  def send_to_ghtk
    result, message = GhtkService.new(params[:order_id]).place_ghtk_order
  end

  private
    def get_customer_id
      customer = Customer.find_by(email: current_user.email)
      customer.present? ? customer.customer_id : nil
    end

    def get_all_orders
      page = 1
      orders = []
      count = ShopifyAPI::Order.count
      if count > 0
        page += count.divmod(250).first
        while page > 0
          puts "Processing page #{page}"
          orders += ShopifyAPI::Order.find(:all, params: { status: "any", limit: 250, page: page })
          page -= 1
        end
      end
      orders
    end
end
