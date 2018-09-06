json.extract! product, :id, :title, :product_id, :price, :currency, :created_at, :updated_at
json.url product_url(product, format: :json)
