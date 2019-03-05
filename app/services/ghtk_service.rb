class GhtkService
  require "uri"
  require "net/http"

  attr_reader :order

  TOKEN = "06EAB5098DA0eA1302237f932d63319cD60202Ac"

  def initialize(order_id)
    @order = Order.find(order_id)
  end

  def place_ghtk_order
    place_order
  end

  private

    def place_order
      data_params = set_ghtk_order_params
      begin
        url = URI.parse('https://services.giaohangtietkiem.vn/services/shipment/order')
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        data = data_params.to_json
        headers = {
            'Token' => TOKEN,
            'Content-Type' => 'application/json'
        }
        resp = http.post(url.path, data, headers)
        resp_body = resp.body
        result = JSON.parse(resp.body)
        if result["success"]
          order.update(ghtk_label: result["order"]["label"], fee: result["order"]["fee"])
        end
      rescue => e
        [false, result['message']]
      end
      [true, order.ghtk_label]
    end

    def set_ghtk_order_params
      { products: set_product_params, order: order_params }
    end

    def set_product_params
      order.items.map { |item| { name: item.name, weight: item.weight,
                  quantity: item.quantity, amount: item.amount  } }
    end

    def order_params
      # province, district = set_location
      #phone_number = set_phone_number
      {
        id: order.order_id,
        pick_name: "Saint L Beau",
        pick_address: "nhà N06 119 Phổ Quang ( khu nhà phố Golden Masion ), Phổ Quang",
        pick_province: "Ho Chi Minh",
        pick_district: "Phường 9, Quận Phú nhuận",
        pick_tel: '0901318892',
        tel: order.phone_number,
        name: order.phone_number,
        address: order.address1,
        province: order.province,
        district: order.district,
        is_freeship: "1",
        pick_date: Time.now,
        pick_money: order.total,
        value: order.total
      }
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
