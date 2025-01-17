class FixSpecaltiesColoumnName < ActiveRecord::Migration[7.2]
  def change
    rename_column :experts, :specalties_details, :specialty_details
  end
end
