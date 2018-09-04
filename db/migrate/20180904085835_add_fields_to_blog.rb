class AddFieldsToBlog < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :is_featured, :boolean, default: false
    add_column :blogs, :feature_date, :datetime
  end
end
