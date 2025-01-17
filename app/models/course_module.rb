class CourseModule < ApplicationRecord
    has_and_belongs_to_many :experts

    validates :name, presence: true
    validates :description, presence: true

    def self.ransackable_attributes(auth_object = nil)
        [ "created_at", "description", "id", "id_value", "name", "updated_at" ]
    end
end
