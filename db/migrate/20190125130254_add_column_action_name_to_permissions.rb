class AddColumnActionNameToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_column :permissions, :action_name, :string
  end
end
