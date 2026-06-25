class Member < ApplicationRecord
  enum :status, { active: 0, suspended: 1, expired: 2 }, default: :active

  has_many :bookings, dependent: :restrict_with_error

  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true

  def active?
    status == 'active'
  end
end
