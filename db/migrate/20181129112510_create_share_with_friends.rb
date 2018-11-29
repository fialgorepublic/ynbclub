class CreateShareWithFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :share_with_friends do |t|
      t.string :reward_text
      t.string :earch_coins_text
      t.string :fb_btn_text
      t.string :twitter_btn_text
      t.string :email_btn_text

      t.timestamps
    end
  end
end
