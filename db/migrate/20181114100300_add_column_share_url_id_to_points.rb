class AddColumnShareUrlIdToPoints < ActiveRecord::Migration[5.1]
  def change
    add_column :points, :share_url_id, :integer
  end
end
