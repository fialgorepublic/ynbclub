class ChangeColumnNamesInCommissionHistories < ActiveRecord::Migration[5.1]
  def change
    rename_column :commission_histories, :total_income_was, :old_income
    rename_column :commission_histories, :with_commission,  :new_income
  end
end
