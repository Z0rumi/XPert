class Category < ApplicationRecord
    has_and_belongs_to_many :experts

    validates :name, presence: true

    def self.ransackable_attributes(auth_object = nil)
      %w[id name created_at updated_at]
    end
end
