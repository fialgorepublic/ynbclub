module OrdersHelper
  def customer_name order
    begin
      customer = order.customer
      return [customer.first_name, customer.last_name].join(' ') if customer.first_name.present? || customer.last_name.present?
      customer.email
    rescue => ex
      "--"
    end
  end

  def fulfillment_status order
    order.fulfillment_status.present? ?  order.fulfillment_status : "Unfulfilled"
  end

  def order_date order
    if order.created_at.to_date == Date.today
      order.created_at.to_time.strftime("%H:%M %P")
    elsif order.created_at.to_date == Date.yesterday
      order.created_at.to_time.strftime("yesterday %H:%M %P")
    else
      order.created_at.to_time.strftime("%b %d, %H:%M %P")
    end
  end
end
