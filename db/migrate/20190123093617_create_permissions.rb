class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.references :user, index: true
      t.string     :action_name, array: true, default: []
      t.string     :controller_name

      t.timestamps
    end

    add_foreign_key :permissions, :users, on_delete: :cascade
  end
end
