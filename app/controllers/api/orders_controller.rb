class Api::OrdersController < ApplicationController

  def last_order
    @order = Order.first
    get_order = @order.attributes.merge(order_number: @order.order_name, address: @order.address, price: @order.total).except("id", "order_id", "email", "ghtk_label", "ghtk_status", "postcode", "phone_number", "customer_name", "tracking_link", "created_at", "updated_at", "sent_to_ghtk", "order_created_at", "fulfilment_status", "financial_status", "city_id", "district_id", "province_id", "ward_id", "picked_phone", "transport_type", "store")
    render json: get_order
  end
end