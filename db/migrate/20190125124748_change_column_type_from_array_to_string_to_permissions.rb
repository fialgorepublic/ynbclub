class ChangeColumnTypeFromArrayToStringToPermissions < ActiveRecord::Migration[5.1]
  def change
    change_column :permissions, :action_name, :string, default: ''
  end
end
