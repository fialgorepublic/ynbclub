class OrderService
  attr_reader :order, :params

  def initialize(params)
    @params = params
  end

  def create_order
    create
  end

  def update_address
    order = Order.find_by_id(params[:order_id])
    return false if order.blank?
    order.update(
      city_id: params[:city], province_id: params[:province], customer_name: params[:customer_name],
      district_id: params[:district], ward_id: params[:ward], address: params[:address], transport_type: params[:transport_type]
    )
  end

  private

    def create
      order = Order.find_by(order_id: params['id'])
      return [false, order] if order.present?

      order = Order.create(order_params.merge(address_params))
      [true, order]
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
        financial_status:   params['financial_status'],
        fulfilment_status:  fulfillment_status,
        items_attributes:   items_attributes,
        store:              set_store
      }
    end

    def name
      return [params['billing_address']['first_name'], params['billing_address']['last_name']].join(' ') if params['billing_address'].present?
      return [params['customer']['first_name'], params['customer']['last_name']].join(' ') if params['customer'].present?
      ''
    end

    def phone_number
      phone_number = params['billing_address'].present? ? params["billing_address"]["phone"].delete(" ") : '0911222333'
      phone_number = phone_number.to_s.gsub('+84', '0') if phone_number.to_s.include?('+84')
      phone_number
    end

    def items_attributes
      params["line_items"].map { |line_item| { name: line_item["title"], weight: line_item["grams"].to_f/1000,
                  quantity: line_item["quantity"], amount: line_item["price"]} }
    end

    # def sent_to_ghtk?
    #   params['email'].present? ? params['email'].include?('facebook.com') : false
    # end

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
      city = City.find_by(name: city_name)
      city.present? ? city : nil
    end

    def set_store
      status_url = params['order_status_url']
      return "" if status_url.blank?
      return 'SaintlBeau'      if status_url.include?('www.saintlbeau.com')
      return 'ynbclub'         if status_url.include?('ynbclub.com')
      return 'dantrangrang'    if status_url.include?('dantrangrang.com')
      ''
    end
end
