class AddColumnsToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :security_number, :string
    add_column :profiles, :account_number, :string
    add_column :profiles, :acc_holder_name, :string
    add_column :profiles, :bank_name, :string
  end
end
