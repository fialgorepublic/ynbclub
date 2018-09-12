class CreateBlogViews < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_views do |t|
      t.integer :user_id
      t.integer :blog_id

      t.timestamps
    end
  end
end
