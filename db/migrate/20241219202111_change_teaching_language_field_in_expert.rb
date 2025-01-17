class ChangeTeachingLanguageFieldInExpert < ActiveRecord::Migration[7.2]
  def change
    if column_exists?(:experts, :teaching_language)
      remove_column :experts, :teaching_language, :string
      add_column :experts, :teaching_languages, :string, array: true, default: []
    end
  end
end
