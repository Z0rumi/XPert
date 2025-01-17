class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :set_initiated

  before_update :ensure_role_count_on_change
  before_destroy :ensure_role_count_on_destroy

  belongs_to :expert, optional: true

  enum :role, { expert: 0, intern: 1, staff: 2, admin: 3 }

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :expert
  end

  def set_initiated
    self.initiated = false
  end

  def ensure_role_count_on_change
    return unless role_changed?

    validate_minimum_role_count(role_was)
  end

  def ensure_role_count_on_destroy
    validate_minimum_role_count(role)
  end

  def validate_minimum_role_count(role_to_check)
    if role_to_check != "expert"
      if User.where(role: role_to_check).count <= 1
        role_name = I18n.t("roles.#{role_to_check}", default: role_to_check.to_s.humanize)
        errors.add(:base, "Es muss mindestens ein Benutzer mit der Rolle #{role_name} existieren.")
        throw(:abort)
      end
    end
  end
end
