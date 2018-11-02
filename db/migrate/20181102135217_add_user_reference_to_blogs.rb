class AddUserReferenceToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_reference :blogs, :user, index: true
    add_foreign_key :blogs, :users, on_delete: :cascade
  end
end
