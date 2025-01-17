class ChangeCommunicationLanguageFieldInExpert < ActiveRecord::Migration[7.2]
  def change
    if column_exists?(:experts, :communication_language)
      remove_column :experts, :communication_language, :string
      add_column :experts, :communication_languages, :string, array: true, default: []
    end
  end
end
