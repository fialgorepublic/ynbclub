class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :order, index: true
      t.string     :name
      t.float      :amount, default: 0.00
      t.integer    :quantity
      t.float      :weight, default: 0.00

      t.timestamps
    end
    add_foreign_key :items, :orders, on_delete: :cascade
  end
end
