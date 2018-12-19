class AddColumnGhtkStatusToReferralSales < ActiveRecord::Migration[5.1]
  def change
    add_column :referral_sales, :ghtk_status, :integer
  end
end
