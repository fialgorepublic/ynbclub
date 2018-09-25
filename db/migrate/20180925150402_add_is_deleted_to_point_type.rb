class AddIsDeletedToPointType < ActiveRecord::Migration[5.1]
  def change
    add_column :point_types, :is_deleted, :boolean, default: false
  end
end
