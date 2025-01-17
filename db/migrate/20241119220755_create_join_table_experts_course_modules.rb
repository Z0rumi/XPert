class CreateJoinTableExpertsCourseModules < ActiveRecord::Migration[7.2]
  def change
    create_join_table :experts, :course_modules do |t|
      # t.index [:expert_id, :course_module_id]
      # t.index [:course_module_id, :expert_id]
    end
  end
end
