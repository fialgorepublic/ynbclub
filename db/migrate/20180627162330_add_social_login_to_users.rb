class AddSocialLoginToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :social_login, :boolean, default: false
  end
end
