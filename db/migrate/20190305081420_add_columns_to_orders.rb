class AddColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :sent_to_ghtk, :boolean, default: false
    add_column :orders, :order_created_at, :string
  end
end
