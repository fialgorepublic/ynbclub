class AddUserIdReferenceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference   :groups, :user, index: true
    add_foreign_key :groups, :users, on_delete: :cascade
  end
end
