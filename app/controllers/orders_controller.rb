class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :authorize_user!, except: [:create]
  skip_before_action :block_banned_users, only: [:create]
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
    @q = Order.ransack(params[:q])
    orders = @q.result(distinct: true)
    @orders = orders.includes(:city, :district, :province, :ward, :items).paginate(page: params[:page])
  end

  def create
    @success, @order = OrderService.new(params[:order]).create_order
    if @success
      @response_code, @message = Esms.send_sms(to: @order.phone_number, content: Order::MESSAGE_CONTENT)

      ActionCable.server.broadcast 'orders',
      order: redner_partial(@order),
      response_code: @response_code,
      message: @message
    end
  end

  def update
    if OrderService.new(order_params).update_address
      respond_to do |format|
        format.html
        format.js
      end
      # redirect_to orders_path
    else
      respond_to do |format|
        format.html
        format.js
      end
      # redirect_to orders_path
    end
  end

  def my
    orders = Order.user_orders(current_user.email)
    @orders = orders.paginate(page: params[:page])
  end


  def send_to_ghtk
    @result, @message, @order_id = GhtkService.new(params[:order_id]).place_ghtk_order

    respond_to do |format|
      format.js
    end
  end

  def edit_address
    @order = Order.find(params[:order_id])
    @cities = City.pluck(:name, :id)
    respond_to do |format|
      format.js
    end
  end

  def edit_product_warranty
    @order = Order.find(params[:order_id])
    @products = @order.items
  end

  def district_cities
    city = City.includes(:districts, :provinces).find_by(id: params[:city_id])
    @districts = city.districts.pluck(:name, :id)
    @provinces = city.provinces.pluck(:name, :id)
    @order = Order.find(params[:order_id])
    respond_to do |format|
      format.js
    end
  end

  def wards
    # province = Province.includes(:wards).find_by_id(params[:province_id])
    district = District.includes(:wards).find_by_id(params[:district_id])
    @order = Order.find(params[:order_id])
    # if province.present? && district.present?
    #   wards = province.wards + district.wards
    # elsif province.present?
    #   wards = province.wards
    # if district.present?
    wards = district.wards
    # end
    @wards = wards.pluck(:name, :id)
  end

  def update_phone_status
    order = Order.find(params[:order_id])
    if order.update(picked_phone: params[:status].to_i)
      result = true
    else
      result = false
    end
    ActionCable.server.broadcast "orders",
      order_id: order.id,
      status: params[:status]
    render json: { result: result, order: order.id }
  end

  def gthk_status
  end

  def order_status
    if params[:order_id].present?
      order = Order.where("phone_number = ? OR order_name = ?", params[:order_id].delete(" "), "##{params[:order_id]}").first
      if order.present?
        if order.ghtk_label.present?
        @order_status = CheckOrderService.new(order.id).check_status
        else
          @order_status = I18n.t('order_status.ghtk_label')
        end
      else
        @order_status = I18n.t('order_status.order_unavailable')
      end
    end
  end

  def update_status
    UpdateOrderStatusJob.perform_later
    respond_to do |format|
      format.js
    end
  end

  private

    def order_params
      params.require(:order).permit(:city, :province, :address, :ward, :district, :order_id, :transport_type, :customer_name)
    end

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

    def redner_partial(order)
      render partial: 'orders/last_order',
      locals: {
        order: order
      }
    end
end
