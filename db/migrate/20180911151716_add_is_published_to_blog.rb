class AddIsPublishedToBlog < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :is_published, :boolean, default: false
  end
end
