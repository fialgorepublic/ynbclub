class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :product_id
      t.float :price
      t.string :currency
      t.integer :blog_id

      t.timestamps
    end
  end
end
