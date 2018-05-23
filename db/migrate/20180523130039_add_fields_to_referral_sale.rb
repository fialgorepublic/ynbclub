class AddFieldsToReferralSale < ActiveRecord::Migration[5.1]
  def change
    add_column :referral_sales, :name, :string
    add_column :referral_sales, :email, :string
    add_column :referral_sales, :address, :text
    add_column :referral_sales, :shopdomain, :string
    add_column :referral_sales, :price, :string
  end
end
