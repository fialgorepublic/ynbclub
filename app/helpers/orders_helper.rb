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
    order.fulfilment_status.present? ?  order.fulfilment_status : "Unfulfilled"
  end

  def  options_for_warrenty_dropdown
    [
      ['1 Year', 1],
      ['2 Year', 2],
    ]
  end
end
