class AddReferenceNoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reference_no, :string
  end
end
