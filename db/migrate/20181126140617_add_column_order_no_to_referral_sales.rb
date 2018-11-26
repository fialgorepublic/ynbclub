class AddColumnOrderNoToReferralSales < ActiveRecord::Migration[5.1]
  def change
    add_column :referral_sales, :order_no, :string
  end
end
