class DeleteCategoryColumnsInExpert < ActiveRecord::Migration[7.2]
  def change
    remove_column :experts, :category, :string
    remove_column :experts, :specialty_details, :text
  end
end
