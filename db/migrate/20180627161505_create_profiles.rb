class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :phone_number
      t.string :first_name
      t.string :surname
      t.string :gender
      t.datetime :date_of_birth
      t.string :address_line_1
      t.string :address_line_2
      t.string :state
      t.string :city
      t.string :zip_code
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
