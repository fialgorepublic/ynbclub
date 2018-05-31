class CreatePointTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :point_types do |t|
      t.string :name
      t.float :point

      t.timestamps
    end
  end
end
