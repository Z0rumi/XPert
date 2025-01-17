class ChangeTravelWillingnessFieldInExpert < ActiveRecord::Migration[7.2]
  def change
    if column_exists?(:experts, :travel_willingness)
      remove_column :experts, :travel_willingness, :string
      add_column :experts, :travel_willingnesses, :string, array: true, default: []
    end
  end
end
