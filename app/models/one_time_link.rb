class OneTimeLink < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :used, inclusion: { in: [ true, false ] }
  validates :expires_at, presence: true
end
