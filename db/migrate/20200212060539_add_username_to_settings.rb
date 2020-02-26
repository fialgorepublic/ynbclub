class AddUsernameToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :username, :string
  end
end
