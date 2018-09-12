class AddBuyerShowToBlog < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :buyer_show, :boolean, default: false
  end
end
