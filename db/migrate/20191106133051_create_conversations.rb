class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.string     :subject
      t.string     :body
      t.references :user,          index: true
      t.references :group,         index: true
      t.text       :tags,          default: [], array: true
      t.integer    :parent_id
      t.integer    :replies_count, default: 0
      t.integer    :likes_count,   default: 0
 
      t.timestamps
    end

    add_foreign_key  :conversations, :users,  on_delete: :cascade
    add_foreign_key  :conversations, :groups, on_delete: :cascade
  end
end
