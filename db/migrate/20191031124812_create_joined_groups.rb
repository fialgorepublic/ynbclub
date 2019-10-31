class CreateJoinedGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :joined_groups do |t|
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps
    end

    add_foreign_key :joined_groups, :users, on_delete: :cascade
    add_foreign_key :joined_groups, :groups, on_delete: :cascade
  end
end
