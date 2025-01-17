class Expert < ApplicationRecord
  has_one :user
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :course_modules
  has_and_belongs_to_many :projects
  has_one_attached :cv

  before_destroy :reset_user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_NUMBER_REGEX = /\A\+?[\d\s\-()]{5,20}\z/
  VALID_DAILY_RATE_REGEX = /\A\d+(,\d{1,2})?\z/
  VALID_HOURLY_RATE_REGEX = /\A\d+(,\d{1,2})?\z/

  validates :salutation, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :nationality, presence: true
  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX, message: "Bitte geben SIe eine gültige Telefonnummer an." }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: "Bitte geben SIe eine gültige E-Mail-Adresse an." }
  validates :location, presence: true
  validates :communication_languages, presence: true
  validates :teaching_languages, presence: true
  validates :hourly_rate, presence: true, format: { with: VALID_HOURLY_RATE_REGEX, message: "Bitte geben Sie einen gültigen Stundensatz ein (z. B. 100, 30,50)." }
  validates :daily_rate, presence: true, format: { with: VALID_DAILY_RATE_REGEX, message: "Bitte geben Sie einen gültigen Tagessatz ein (z. B. 1.000, 500,50)." }
  validates :travel_willingnesses, presence: true
  validates :availability, presence: true
  validates :china_experience, presence: true
  validates :institution_association, inclusion: { in: [ true, false ], message: "Bitte wählen Sie aus." }
  validates :institution, presence: { message: "Bitte geben Sie Ihre Institution an." }, if: :institution_association?
  validates :cv, content_type: [ "application/pdf", "image/png", "image/jpg", "image/jpeg" ]
  validates :cv, size: { less_than: 10.megabytes, message: "Datei darf maximal 10MB groß sein." }


  validate :must_have_category

  private

  def must_have_category
    if categories.empty?
      errors.add(:categories, "Mindestens ein Thema/Fachgebiet muss ausgewählt werden.")
    end
  end

  # Concat first and last name to :full_name attribut for filter
  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new(
      "||",
      parent.table[:first_name],
      Arel::Nodes.build_quoted(" ")
    ).concat(parent.table[:last_name])
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "availability", "china_experience", "communication_language", "cooperation_opportunity", "created_at", "email", "horly_rate", "daily_rate", "first_name", "id", "institution", "institution_association", "extra_category", "last_name", "location", "nationality", "phone_number", "remarks", "salutation", "teaching_language", "title", "travel_willingness", "updated_at", "full_name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "categories", "course_modules" ]
  end


  def reset_user
    return unless user

    user.update(expert_id: nil, initiated: false)
  end
end
