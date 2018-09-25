class AddFiledsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :identity_card, :string
    add_column :users, :surplus, :string
    add_column :users, :paid, :string
    add_column :users, :total_income, :float
    add_column :users, :status, :string
  end
end
