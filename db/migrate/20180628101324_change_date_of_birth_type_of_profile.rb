class ChangeDateOfBirthTypeOfProfile < ActiveRecord::Migration[5.1]
  def change
    change_column :profiles, :date_of_birth, :date
  end
end
