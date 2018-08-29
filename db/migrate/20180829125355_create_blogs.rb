class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :promote_post
      t.text :description
      t.integer :category_id

      t.timestamps
    end
  end
end
