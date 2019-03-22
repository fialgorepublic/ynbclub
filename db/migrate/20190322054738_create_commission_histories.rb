class CreateCommissionHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :commission_histories do |t|
      t.references :user, index: true
      t.float      :total_income_was
      t.float      :with_commission
      t.string     :order_no

      t.timestamps
    end

    add_foreign_key :commission_histories, :users, on_delete: :cascade
  end
end
