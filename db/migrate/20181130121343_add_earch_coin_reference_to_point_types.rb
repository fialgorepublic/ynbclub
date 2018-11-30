class AddEarchCoinReferenceToPointTypes < ActiveRecord::Migration[5.1]
  def change
    add_reference :point_types, :earn_coin, index: true
    add_foreign_key :point_types, :earn_coins, on_delete: :cascade
  end
end
