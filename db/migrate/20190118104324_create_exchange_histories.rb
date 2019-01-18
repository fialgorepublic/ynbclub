class CreateExchangeHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_histories do |t|
      t.string     :discount_code
      t.references :user, index: true
      t.integer    :exchanged_coins
      t.float      :rewarded_amount

      t.timestamps
    end

    add_foreign_key :exchange_histories, :users, on_delete: :cascade
  end
end
