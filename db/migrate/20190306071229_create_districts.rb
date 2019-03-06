class CreateDistricts < ActiveRecord::Migration[5.1]
  def change
    create_table :districts do |t|
      t.string     :name
      t.references :city, index: true

      t.timestamps
    end

    add_foreign_key :districts, :cities, on_delete: :cascade
  end
end
