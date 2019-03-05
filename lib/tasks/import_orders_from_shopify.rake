desc 'Import Orders from shopify'

task import_orders_from_shopify: :environment do
  @session = ShopifyAPI::Session.new("saintlbeau.myshopify.com", "65f08aa2bc5386c55298ed566ad18ccd")
  ShopifyAPI::Base.activate_session(@session)

  orders = []
  count = ShopifyAPI::Order.count
  if count > 0
    mod = count.divmod(250)
    page = mod.first
    page += mod.last > 0 ? 1 : 0
    while page > 0
      puts "Processing page #{page}"
      orders += ShopifyAPI::Order.find(:all, params: { status: "any", limit: 250, page: page })
      page -= 1
    end
  end

  orders.each do |order|
    result, name = OrderService.new(JSON.parse(order.to_json)).create_order
    puts "Order #{name} is imported successfully."
  end
end
