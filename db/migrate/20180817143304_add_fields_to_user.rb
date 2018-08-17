class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :shop_no, :string
    add_column :users, :money, :string
  end
end
