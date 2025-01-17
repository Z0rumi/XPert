class AddDailyRateToExperts < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:experts, :daily_rate)
      add_column :experts, :daily_rate, :integer
    end
  end
end
