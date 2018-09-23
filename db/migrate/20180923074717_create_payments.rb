class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :payment_code
      t.date :payment_date
      t.float :amount
      t.string :recipient_name
      t.string :email
      t.string :number_math
      t.string :status
      t.string :note

      t.timestamps
    end
  end
end
