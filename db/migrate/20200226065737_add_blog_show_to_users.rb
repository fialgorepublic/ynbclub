class AddBlogShowToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :blog_show, :boolean, default: false
  end
end
