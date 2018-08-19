class AddIsShopifyUserToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_shopify_user, :boolean, default: false
  end
end
