class Schedule < ApplicationRecord
  MAX_CAPACITY = 12

  belongs_to :course
  belongs_to :coach
  has_many :bookings, dependent: :restrict_with_error
  has_many :active_bookings, -> { where.not(status: Booking.statuses[:cancelled]) }, class_name: 'Booking'

  validates :start_time, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: MAX_CAPACITY }
  validates :coach_id, uniqueness: { scope: :start_time, message: '该教练此时间已有排课' }

  def expired?
    start_time < Time.current
  end

  def full?
    active_bookings.count >= capacity
  end

  def remaining_slots
    [capacity - active_bookings.count, 0].max
  end

  def end_time
    start_time + (course&.duration_minutes || 60).minutes
  end

  scope :upcoming, -> { where('start_time >= ?', Time.current).order(start_time: :asc) }
  scope :this_week, -> { where(start_time: Date.today.beginning_of_week..Date.today.end_of_week.end_of_day).order(start_time: :asc) }
  scope :for_week, ->(date) { where(start_time: date.beginning_of_week..date.end_of_week.end_of_day).order(start_time: :asc) }
end
