class Coach < ApplicationRecord
  has_many :schedules, dependent: :restrict_with_error

  validates :name, presence: true
  validates :phone, uniqueness: true, allow_nil: true
end
