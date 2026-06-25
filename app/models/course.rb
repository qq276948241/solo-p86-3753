class Course < ApplicationRecord
  has_many :schedules, dependent: :restrict_with_error

  validates :name, presence: true
  validates :duration_minutes, presence: true, numericality: { greater_than: 0 }
end
