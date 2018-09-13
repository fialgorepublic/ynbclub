class AddUrlTypeToShareUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :share_urls, :url_type, :string
  end
end
