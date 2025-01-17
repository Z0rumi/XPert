class AddHourlyRateToExperts < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:experts, :hourly_rate)
      add_column :experts, :hourly_rate, :integer
    end
  end
end
