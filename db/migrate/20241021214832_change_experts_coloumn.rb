class ChangeExpertsColoumn < ActiveRecord::Migration[7.2]
  def change
    change_column :experts, :daily_rate, :string
    rename_column :experts, :titles, :title
    rename_column :experts, :daily_rate, :fee
    rename_column :experts, :specialty, :category
  end
end
