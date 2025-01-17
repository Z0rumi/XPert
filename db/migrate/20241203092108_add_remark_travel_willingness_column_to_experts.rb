class AddRemarkTravelWillingnessColumnToExperts < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:experts, :remark_travel_willingness)
      add_column :experts, :remark_travel_willingness, :string
    end
  end
end
