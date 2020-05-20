class Api::OrdersController < ApplicationController
  skip_before_action :block_banned_users

  def last_order
    @order = Order.first
    get_order = @order.attributes.merge(order_number: @order.order_name, address: @order.address, price: @order.total, phone_number: @order.phone_number).except("order_name", "total", "id", "order_id", "email", "ghtk_label", "ghtk_status", "postcode", "customer_name", "tracking_link", "created_at", "updated_at", "sent_to_ghtk", "order_created_at", "fulfilment_status", "financial_status", "city_id", "district_id", "province_id", "ward_id", "picked_phone", "transport_type", "store")
    render json: get_order
  end

  def callback_url
    Rails.logger.info "===========================>>>>>>>>>>>>>>>><<<<<<<<<<<<<>#{params.inspect}"
    render json: [];
  end
end
