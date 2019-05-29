class AddStoreColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :store, :string
  end
end
