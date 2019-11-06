class AddConversationsCountToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :conversations_count, :integer, default: 0
  end
end
