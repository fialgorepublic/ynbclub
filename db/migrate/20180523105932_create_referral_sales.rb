class CreateReferralSales < ActiveRecord::Migration[5.1]
  def change
    create_table :referral_sales do |t|
      t.integer :user_id
      t.string :order_id

      t.timestamps
    end
  end
end
