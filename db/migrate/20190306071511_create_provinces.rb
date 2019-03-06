class CreateProvinces < ActiveRecord::Migration[5.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.references :city, index: true

      t.timestamps
    end
    add_foreign_key :provinces, :cities, on_delete: :cascade
  end
end
