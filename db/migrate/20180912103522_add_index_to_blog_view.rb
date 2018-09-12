class AddIndexToBlogView < ActiveRecord::Migration[5.1]
  def change
    add_index :blog_views, [:user_id, :blog_id], unique: true
  end
end
