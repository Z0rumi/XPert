class RemoveUserReferenceFromExperts < ActiveRecord::Migration[7.2]
  def change
    remove_reference :experts, :user, foreign_key: true
  end
end
