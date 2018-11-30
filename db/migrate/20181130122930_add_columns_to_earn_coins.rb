class AddColumnsToEarnCoins < ActiveRecord::Migration[5.1]
  def change
    add_column :earn_coins, :coins, :string
    add_column :earn_coins, :price, :string
  end
end
