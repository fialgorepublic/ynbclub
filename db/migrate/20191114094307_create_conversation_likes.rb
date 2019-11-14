class CreateConversationLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :conversation_likes do |t|
      t.references :user,         index: true
      t.references :conversation, index: true

      t.timestamps
    end
    add_foreign_key :conversation_likes, :users,        on_delete: :cascade
    add_foreign_key :conversation_likes, :conversations, on_delete: :cascade
  end
end
