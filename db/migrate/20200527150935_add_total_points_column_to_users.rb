class AddTotalPointsColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :total_points, :float, default: 0.0
  end
end
