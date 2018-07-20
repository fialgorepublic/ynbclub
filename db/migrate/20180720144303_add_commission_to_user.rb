class AddCommissionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :commission, :float
  end
end
