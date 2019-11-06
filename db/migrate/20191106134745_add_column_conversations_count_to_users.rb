class AddColumnConversationsCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :conversations_count, :integer, default: 0
  end
end
