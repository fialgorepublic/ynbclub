class CreateCommentActions < ActiveRecord::Migration[5.1]
  def change
    create_table :comment_actions do |t|
      t.boolean :like
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true

      t.timestamps
    end
  end
end
