class AddColumnDiscountCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discount_code, :string
  end
end
