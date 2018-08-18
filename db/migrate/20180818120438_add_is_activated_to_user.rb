class AddIsActivatedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_activated, :boolean, default: false
  end
end
