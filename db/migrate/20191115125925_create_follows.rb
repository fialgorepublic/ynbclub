class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer  :follower_id,  index: true
      t.integer  :following_id, index: true

      t.timestamps
    end

    add_index :follows, [:follower_id, :following_id]
  end
end
