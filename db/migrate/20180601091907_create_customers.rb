class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email, default: ""
      t.string :customer_id

      t.timestamps
    end
  end
end
