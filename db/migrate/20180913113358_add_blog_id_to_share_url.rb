class AddBlogIdToShareUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :share_urls, :blog_id, :integer
  end
end
