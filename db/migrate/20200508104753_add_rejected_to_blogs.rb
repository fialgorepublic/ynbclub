class AddRejectedToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :rejected, :boolean, default: false
  end
end
