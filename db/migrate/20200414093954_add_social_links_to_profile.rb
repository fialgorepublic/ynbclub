class AddSocialLinksToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :facebook, :string
    add_column :profiles, :instagram, :string
    add_column :profiles, :youtube, :string
  end
end
