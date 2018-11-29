class RenameColumnInShareWithFriends < ActiveRecord::Migration[5.1]
  def change
    rename_column :share_with_friends, :earch_coins_text, :earn_coins_text
  end
end
