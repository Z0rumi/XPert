class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.string :main_topics
      t.date :start_date
      t.date :end_date
      t.string :project_type
      t.string :client
      t.string :location
      t.string :city

      t.timestamps
    end
  end
end
