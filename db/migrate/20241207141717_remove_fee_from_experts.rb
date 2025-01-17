class RemoveFeeFromExperts < ActiveRecord::Migration[7.2]
  def change
    if column_exists?(:experts, :fee)
      remove_column :experts, :fee, :string
    end
  end
end
