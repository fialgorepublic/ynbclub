class AddFulfilmentStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :fulfilment_status, :string
    add_column :orders, :financial_status, :string
  end
end
