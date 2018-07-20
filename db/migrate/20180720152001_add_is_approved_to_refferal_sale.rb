class AddIsApprovedToRefferalSale < ActiveRecord::Migration[5.1]
  def change
    add_column :referral_sales, :is_approved, :boolean, default: false
  end
end
