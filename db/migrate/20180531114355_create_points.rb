class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :point_type_id
      t.float :point_value

      t.timestamps
    end
  end
end
