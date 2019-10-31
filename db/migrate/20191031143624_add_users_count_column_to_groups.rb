class AddUsersCountColumnToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :users_count, :integer, default: 0
  end
end
