class Booking < ApplicationRecord
  BOOKING_FULL_CODE = 'BOOKING_FULL'
  DUPLICATE_BOOKING_CODE = 'DUPLICATE_BOOKING'
  SCHEDULE_EXPIRED_CODE = 'SCHEDULE_EXPIRED'
  MEMBER_INACTIVE_CODE = 'MEMBER_INACTIVE'
  ALREADY_CANCELLED_CODE = 'ALREADY_CANCELLED'
  ALREADY_CHECKED_IN_CODE = 'ALREADY_CHECKED_IN'

  enum :status, { booked: 0, checked_in: 1, cancelled: 2, no_show: 3 }, default: :booked

  belongs_to :member
  belongs_to :schedule
  has_one :check_in, dependent: :destroy

  validate :validate_schedule_not_full, on: :create
  validate :validate_schedule_not_expired, on: :create
  validate :validate_member_active, on: :create
  validate :validate_no_duplicate_active_booking, on: :create

  def cancel!
    return errors.add(:base, ALREADY_CANCELLED_CODE) if cancelled?
    return errors.add(:base, ALREADY_CHECKED_IN_CODE) if checked_in?

    transaction do
      update!(status: :cancelled, cancelled_at: Time.current)
    end
    true
  end

  private

  def validate_schedule_not_full
    return unless schedule
    return unless schedule.full?

    errors.add(:base, BOOKING_FULL_CODE)
  end

  def validate_schedule_not_expired
    return unless schedule
    return unless schedule.expired?

    errors.add(:base, SCHEDULE_EXPIRED_CODE)
  end

  def validate_member_active
    return unless member
    return if member.active?

    errors.add(:base, MEMBER_INACTIVE_CODE)
  end

  def validate_no_duplicate_active_booking
    return unless member && schedule

    existing = Booking.where(member_id: member_id, schedule_id: schedule_id)
                      .where.not(status: Booking.statuses[:cancelled])
                      .exists?
    return unless existing

    errors.add(:base, DUPLICATE_BOOKING_CODE)
  end
end
