class CheckIn < ApplicationRecord
  BOOKING_NOT_FOUND_CODE = 'BOOKING_NOT_FOUND'
  BOOKING_CANCELLED_CODE = 'BOOKING_CANCELLED'
  SCHEDULE_NOT_STARTED_CODE = 'SCHEDULE_NOT_STARTED'
  ALREADY_CHECKED_IN_CODE = 'ALREADY_CHECKED_IN'

  belongs_to :booking

  validates :booking_id, uniqueness: { message: '该预约已签到' }
  validate :validate_booking_active, on: :create
  validate :validate_within_checkin_window, on: :create

  after_create :mark_booking_checked_in

  private

  def mark_booking_checked_in
    booking.update!(status: :checked_in)
  end

  def validate_booking_active
    return unless booking

    if booking.cancelled?
      errors.add(:base, BOOKING_CANCELLED_CODE)
    end
  end

  def validate_within_checkin_window
    return unless booking&.schedule

    start_time = booking.schedule.start_time
    checkin_start = start_time - 30.minutes
    checkin_end = start_time + 15.minutes

    now = checked_in_at || Time.current

    if now < checkin_start
      errors.add(:base, SCHEDULE_NOT_STARTED_CODE)
    end
  end
end
