class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string  :order_id
      t.string  :order_name
      t.string  :email
      t.string  :ghtk_label
      t.string  :ghtk_status
      t.string  :address
      t.string  :city
      t.string  :province
      t.string  :postcode
      t.string  :phone_number
      t.string  :customer_name
      t.string  :total
      t.string  :district
      t.string  :ward
      t.string  :tracking_link
      t.boolean :picked_phone, default: true

      t.timestamps
    end
  end
end
