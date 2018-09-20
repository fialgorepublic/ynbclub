class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.float :min_payment
      t.integer :cookie_time

      t.timestamps
    end
  end
end
