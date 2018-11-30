class CreateEarnCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :earn_coins do |t|
      t.string :main_text
      t.string :how_earn_text
      t.string :how_spend_text
      t.string :earn_way

      t.timestamps
    end
  end
end
