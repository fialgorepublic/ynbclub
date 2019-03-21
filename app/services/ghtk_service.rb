class GhtkService
  attr_reader :order, :base_url

  TOKEN = "06EAB5098DA0eA1302237f932d63319cD60202Ac"

  def initialize(order_id)
    @base_url = Rails.env.development? || Rails.env.staging? ? 'https://dev.ghtk.vn' : 'https://services.giaohangtietkiem.vn'
    @order = Order.find(order_id)
  end

  def place_ghtk_order
    if address_present?
      place_order
    else
      [false, "Address is not valid."]
    end
  end

  private
    def address_present?
      order.city.present? && ( order.district.present? || order.province.present? )
    end

    def place_order
      result, message = false, ""
      url = URI.parse("#{base_url}/services/shipment/order")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      # data = data_params.to_json
      headers = {
          'Token' => TOKEN,
          'Content-Type' => 'application/json'
      }
      resp = http.post(url.path, set_ghtk_order_params.to_json, headers)
      resp_body = resp.body
      response = JSON.parse(resp.body)

      if response['success']
        result = update_order(response)
        message = response['message']
        UpdateOrderStatusService.new([] << order ).call
      elsif response['error']
        update_order(response) if order.ghtk_label.blank? || order.ghtk_status.blank?
        result, message = false, response["message"]
      end
      [result, message]
    end

    def update_order response
      response = response['order'] || response['error']
      ghtk_label = response['ghtk_label'].present? ? response['ghtk_label'] : response['label']
      update_params = {
                      ghtk_label:    ghtk_label,
                      ghtk_status:   status(response['status']),
                      sent_to_ghtk:  true
                    }

      update_params.merge(tracking_link: response['tracking_id']) if order.tracking_link.blank?
      order.update(update_params)
    end

    def set_ghtk_order_params
      order = order_params
      order.merge(pick_work_shift: 1) if Date.current.sunday?
      { products: set_product_params, order: order }
    end

    def set_product_params
      order.items.map { |item| { name: item.name, weight: item.weight,
                  quantity: item.quantity, amount: item.amount.to_i  } }
    end

    def order_params
      # province, district = set_location
      #phone_number = set_phone_number
      {
        id:             order.order_id,
        pick_name:      "Saint L Beau",
        pick_address:   "nhà N06 119 Phổ Quang ( khu nhà phố Golden Masion ), Phổ Quang",
        pick_province:  "Ho Chi Minh",
        pick_district:  "Phường 9, Quận Phú nhuận",
        pick_tel:       "0901318892",
        tel:            order.phone_number,
        name:           order.customer_name,
        address:        order.address,
        province:       province_name,
        district:       district_name,
        ward:           order.ward_name,
        is_freeship:    "1",
        pick_date:      Time.now,
        pick_money:     order.total.to_i,
        value:          order.total.to_i
      }
    end

    def province_name
      order.province_name || order.city_name
    end

    def district_name
      order.district_name || order.city_name
    end

    def status ghtk_status
      case ghtk_status
      when '-1' , -1
        'Cancel order'
      when '1' , -1
        'Not yet received'
      when '2', 2
        'Received'
      when '3' , 3
        'Goods taken / Inventory imported'
      when '4' , 4
        'Coordinated delivery / Delivery'
      when '5' , 5
        'Delivered / Uncontrolled'
      when '6' , 6
        'Controled'
      when '7' , 7
        'Do not get the goods'
      when '8' , 8
        'Postpone taking goods'
      when '9' , 9
        'Do not deliver goods'
      when '10' , 10
        'Delay delivery'
      when '11' , 11
        'Debt repayment has been controlled'
      when '12' , 12
        'Coordinated to pick up goods / Taking goods'
      when '13' , 13
        'Order reimbursement'
      when '20' , 20
        'Returning goods (COD holds the goods to pay)'
      when '21' , 21
        'Delivered (COD has finished delivering goods)'
      when '123' , 123
        'Shipper reportedly took the goods'
      when '127' , 127
        'Shipper (employee taking / delivery) reported not getting the goods'
      when '128', 128
        'Shipper delay report picks up goods'
      when '45' , 45
        'Shipper reported delivery'
      when '49' , 49
        'Shipper reported that delivery could not be delivered'
      when '410' , 410
        'Shipper reported delay delivery'
      end
    end

    # def set_location
    #   user_affiliate_profile = get_user

    #   if user_affiliate_profile && user_affiliate_profile["state"] && user_affiliate_profile["city"]
    #     [user_affiliate_profile["state"], user_affiliate_profile["city"]]
    #   else
    #     city = params["billing_address"]["city"]
    #     result = find_state_geolocation(city)
    #     state = result.state if result
    #     state = city if state.blank?
    #     [state, city]
    #   end
    # end

    # def set_phone_number
    #   phone_number = params["billing_address"].present? ? params["billing_address"]["phone"] : "0911222333"
    #   phone_number = phone_number.to_s.gsub('+84', '0') if phone_number.include?('+84')
    #   phone_number
    # end

    # def get_user
    #   url = URI("https://ambassador.saintlbeau.com/users/find_user?email=#{params["email"]}")
    #   response = Net::HTTP.get(url)
    #   response = JSON.parse(response)
    #   response["profile"]
    # end

    # def find_state_geolocation(city)
    #   address = [city, 'Vietnam'].join(', ')
    #   results = Geocoder.search(address)
    #   results.first
    # end
end
