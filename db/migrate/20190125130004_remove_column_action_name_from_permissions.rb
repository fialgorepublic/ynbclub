class RemoveColumnActionNameFromPermissions < ActiveRecord::Migration[5.1]
  def change
    remove_column :permissions, :action_name, :string
  end
end
