class AddGroupCategoryReferenceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :group_category, index: true
    add_foreign_key :groups, :group_categories, on_delete: :cascade
  end
end
