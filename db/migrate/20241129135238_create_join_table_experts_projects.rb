class CreateJoinTableExpertsProjects < ActiveRecord::Migration[7.2]
  def change
    create_join_table :experts, :projects do |t|
      # t.index [:expert_id, :project_id]
      # t.index [:project_id, :expert_id]
    end
  end
end
