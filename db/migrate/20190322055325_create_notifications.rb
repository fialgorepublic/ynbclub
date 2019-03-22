class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.boolean    :archived, default: false
      t.references :source, polymorphic: true
      t.integer    :target_id

      t.timestamps
    end
  end
end
