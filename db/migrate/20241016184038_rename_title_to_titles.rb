class RenameTitleToTitles < ActiveRecord::Migration[7.2]
  def change
    rename_column :experts, :title, :titles
  end
end
