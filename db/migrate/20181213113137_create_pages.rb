class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string     :heading
      t.string     :sub_heading
      t.attachment :image
      t.timestamps
    end
  end
end
