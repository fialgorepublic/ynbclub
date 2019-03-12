class UpdateOrderStatusService
  attr_reader :orders

  TOKEN = "06EAB5098DA0eA1302237f932d63319cD60202Ac"
  PRODUCTION_URL  = 'https://services.giaohangtietkiem.vn'
  DEVELOPMENT_URL = 'https://dev.ghtk.vn'

  def initialize(orders)
    @orders = orders
  end

  def call
    update_status
  end

  private
    def update_status
      orders.each do |order|
        response = get_ghtk_status(order.ghtk_label)
        next unless response['success']
        ghtk_order = response['order']
        order.update(ghtk_status: status(ghtk_order['status']))
      end
    end

    def get_ghtk_status ghtk_label
      url = URI.parse("#{DEVELOPMENT_URL}/services/shipment/v2/#{ghtk_label}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      headers = {
          'Token' => TOKEN
      }
      resp = http.get(url.path, headers)
      JSON.parse(resp.body)
    end

    def status status
      case status
      when '-1', -1
        'Cancel order'
      when '1' , 1
        'Not yet received'
      when '2' , 2
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
      when '128' , 128
        'Shipper delay report picks up goods'
      when '45' , 45
        'Shipper reported delivery'
      when '49' , 49
        'Shipper reported that delivery could not be delivered'
      when '410' , 410
        'Shipper reported delay delivery'
      end
    end
end
