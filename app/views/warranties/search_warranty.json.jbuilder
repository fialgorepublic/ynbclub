json.product_warranties do
  json.array!(@warranties) do |warranty|
    json.id warranty.id
    json.number warranty.number
  end
end
