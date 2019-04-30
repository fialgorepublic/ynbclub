class AddColumnImageUrlToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :image_url, :string
  end
end
