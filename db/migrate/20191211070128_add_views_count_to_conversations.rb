class AddViewsCountToConversations < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :views_count, :integer, default: 0
  end
end
