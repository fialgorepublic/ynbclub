class AddWarrantyNumberAndWarrantyYearToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :warranty_number, :string
    add_column :items, :warranty_valid_for_years, :integer
    add_column :items, :warranty_expiry_date, :datetime
  end
end
