class AddReferenceToOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :district, :string
    remove_column :orders, :province, :string
    remove_column :orders, :city, :string
    remove_column :orders, :ward, :string

    add_reference :orders, :city, index: true
    add_reference :orders, :district, index: true
    add_reference :orders, :province, index: true
    add_reference :orders, :ward, index: true
  end
end
