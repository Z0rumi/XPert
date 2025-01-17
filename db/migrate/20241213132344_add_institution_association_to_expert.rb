class AddInstitutionAssociationToExpert < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:experts, :institution_association)
      add_column :experts, :institution_association, :boolean
    end
  end
end
