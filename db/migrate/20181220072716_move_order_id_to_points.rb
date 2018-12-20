class MoveOrderIdToPoints < ActiveRecord::Migration[5.1]
  def change
    remove_column :share_urls, :order_id, :string
    add_column    :points, :order_id, :string
  end
end
