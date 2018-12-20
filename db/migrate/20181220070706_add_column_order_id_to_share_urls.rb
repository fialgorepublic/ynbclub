class AddColumnOrderIdToShareUrls < ActiveRecord::Migration[5.1]
  def change
    add_column :share_urls, :order_id, :string
  end
end
