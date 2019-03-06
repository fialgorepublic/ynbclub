class OrderService
  attr_reader :order, :params

  def initialize(params)
    @params = params
  end

  def create_order
    [true, create.order_name]
  end

  def update_address
    order = Order.find_by_id(params[:order_id])
    return false if order.blank?
    order.update(city_id: params[:city], province_id: params[:province], district_id: params[:district], ward_id: params[:ward], address: params[:address])
  end

  private

    def create
      order = Order.find_by(order_id: params['id']) || Order.create(order_params.merge(address_params))
    end

    def order_params
      {
        order_id:           params['id'],
        order_name:         params['name'],
        email:              params['email'],
        customer_name:      name,
        phone_number:       phone_number,
        total:              params['total_price'],
        order_created_at:   params['created_at'],
        sent_to_ghtk:       sent_to_ghtk?,
        financial_status:   params['financial_status'],
        fulfilment_status:  fulfillment_status,
        items_attributes:   items_attributes
      }
    end

    def name
      return [params['billing_address']['first_name'], params['billing_address']['last_name']].join(' ') if params['billing_address'].present?
      return [params['customer']['first_name'], params['customer']['last_name']].join(' ') if params['customer'].present?
      ''
    end

    def phone_number
      phone_number = params['billing_address'].present? ? params["billing_address"]["phone"] : '0911222333'
      phone_number = phone_number.to_s.gsub('+84', '0') if phone_number.to_s.include?('+84')
      phone_number
    end

    def items_attributes
      params["line_items"].map { |line_item| { name: line_item["title"], weight: line_item["grams"].to_f/1000,
                  quantity: line_item["quantity"], amount: line_item["price"]  } }
    end

    def sent_to_ghtk?
      params['email'].present? ? params['email'].include?('facebook.com') : false
    end

    def address_params
      if params['billing_address'].present?
        {
          address:           params['billing_address']['address1'],
          city:              find_city(params['billing_address']['city']),
          postcode:          params['billing_address']['zip'],
        }
      else
        {
          address:  '',
          city:     nil,
          postcode: ''

        }
      end
    end

    def fulfillment_status
      params['fulfillment_status'].present? ?  params['fulfillment_status'] : "Unfulfilled"
    end

    def find_city city_name
      city = City.find_by(name: 'name')
      city.presen? ? city : nil
    end
end
