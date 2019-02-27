class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.references :state, index: true

      t.timestamps
    end

    add_foreign_key :cities, :states, on_delete: :cascade
  end
end
