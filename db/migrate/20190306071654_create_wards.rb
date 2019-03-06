class CreateWards < ActiveRecord::Migration[5.1]
  def change
    create_table :wards do |t|
      t.string :name
      t.references :district, index: true
      t.references :province, index: true

      t.timestamps
    end

    add_foreign_key :wards, :districts, on_delete: :cascade
    add_foreign_key :wards, :provinces, on_delete: :cascade
  end
end
