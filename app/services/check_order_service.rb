class CheckOrderService
  attr_reader :order, :base_url

  TOKEN = "06EAB5098DA0eA1302237f932d63319cD60202Ac"

  def initialize(order_id)
    @base_url = Rails.env.development? || Rails.env.staging? ? 'https://dev.ghtk.vn' : 'https://services.giaohangtietkiem.vn'
    @order = Order.find(order_id)
  end

  def check_status
      result, message = false, ""
      url = URI.parse("#{base_url}/services/shipment/v2/#{order.ghtk_label}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      # data = data_params.to_json
      headers = {
          'Token' => TOKEN,
          'Content-Type' => 'application/json'
      }
      resp = http.get(url.path, headers)
      resp_body = resp.body
      response = JSON.parse(resp.body)

      if response['success']
        status = response["order"]["status_text"]
      else
        message = response["message"]
      end
    end

    
end
