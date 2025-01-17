json.extract! project, :id, :project_name, :main_topics, :start_date, :end_date, :project_type, :client, :location, :city, :created_at, :updated_at
json.url project_url(project, format: :json)
