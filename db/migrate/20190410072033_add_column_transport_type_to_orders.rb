class AddColumnTransportTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :transport_type, :integer, default: 1
  end
end
