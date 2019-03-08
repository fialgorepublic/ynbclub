class ChangePickedPhoneToIntegerInOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :picked_phone, :boolean, default: true
    add_column    :orders, :picked_phone, :integer, default: 0
  end
end
