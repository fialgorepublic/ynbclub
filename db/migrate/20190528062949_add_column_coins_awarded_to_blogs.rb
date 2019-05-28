class AddColumnCoinsAwardedToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :coins_awarded, :boolean, default: false
  end
end
