class RemoveSimpleDiscussionTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :forum_posts
    drop_table :forum_subscriptions
    drop_table :forum_threads
    drop_table :forum_categories
  end
end
