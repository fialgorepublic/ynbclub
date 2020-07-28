desc 'Import Orders from shopify'

task import_orders_from_shopify: :environment do
  shopify_session = ShopifyAPI::Session.new(domain: "saintlbeau.myshopify.com", token: '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', api_version: '2019-04')
  ShopifyAPI::Base.activate_session(shopify_session)

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
