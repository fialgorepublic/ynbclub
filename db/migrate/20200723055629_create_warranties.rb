class CreateWarranties < ActiveRecord::Migration[5.2]
  def change
    create_table :warranties do |t|
      t.string :number
      t.string :barcode
      t.integer :item_id
      t.boolean :assigned, default: false
      t.integer :valid_for_years
      t.datetime :expiry_date
      t.datetime :start_date

      t.timestamps
    end
  end
end
