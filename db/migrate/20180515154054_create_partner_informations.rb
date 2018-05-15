class CreatePartnerInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :partner_informations do |t|
      t.string :store_name
      t.string :phone_no
      t.text :address
      t.string :id_number
      t.string :bank_name
      t.string :account_number
      t.string :account_name

      t.timestamps
    end
  end
end
