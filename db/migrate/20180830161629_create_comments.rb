class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :message
      t.integer :user_id
      t.integer :blog_id

      t.timestamps
    end
  end
end
