class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:create, :ghtk_status]
  before_action :authorize_user!, except: [:create, :ghtk_status]
  skip_before_action :verify_authenticity_token, only: [:create, :ghtk_status]

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
    @orders = orders.includes(:city, :district, :province, :ward).paginate(page: params[:page])
  end

  def create
    OrderService.new(params[:order]).create_order
    render head :ok
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
    @result, @message = GhtkService.new(params[:order_id]).place_ghtk_order

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
    render json: { result: result, order: order.id }
  end

  def gthk_status
  end

  def order_status
    if params[:order_id].present?
      order = Order.where("phone_number = ? OR order_name = ?", params[:order_id], params[:order_id] ).first
      if order.present?
        @order_status = CheckOrderService.new(order.id).check_status
      else
        @order_status = "#{t('order_status.order_unavailable')}"
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
end
