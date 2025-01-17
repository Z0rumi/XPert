class Project < ApplicationRecord
    has_and_belongs_to_many :experts
    has_many_attached :documents

    validates :project_name, presence: true
    validates :documents, content_type: [
        "application/pdf",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/msword",
        "application/vnd.ms-excel"
    ]
    validates :documents, size: { less_than: 10.megabytes, message: "Datei darf maximal 10MB groß sein." }


    def self.ransackable_attributes(auth_object = nil)
        [ "city", "client", "created_at", "end_date", "id", "location", "main_topics", "project_name", "project_type", "start_date", "updated_at" ]
    end
end
