class CreateSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :snapshots do |t|
      t.attachment :step1_avatar
      t.attachment :step2_avatar
      t.attachment :step3_avatar
      t.attachment :step4_avatar
      t.string         :step1_text
      t.string         :step2_text
      t.string         :step3_text
      t.string         :step4_text
      t.timestamps
    end
  end
end
