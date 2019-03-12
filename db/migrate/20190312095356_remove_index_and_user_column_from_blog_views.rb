class RemoveIndexAndUserColumnFromBlogViews < ActiveRecord::Migration[5.1]
  def change
    remove_index  :blog_views, column: [:user_id, :blog_id]
    remove_column :blog_views, :user_id, :integer
  end
end
