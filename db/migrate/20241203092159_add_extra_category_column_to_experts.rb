class AddExtraCategoryColumnToExperts < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:experts, :extra_category)
      add_column :experts, :extra_category, :string
    end
  end
end
