class CheckInsController < ApplicationController
  def index
    scope = CheckIn.includes(booking: { member: {}, schedule: [:course, :coach] })

    if params[:schedule_id].present?
      scope = scope.joins(:booking).where(bookings: { schedule_id: params[:schedule_id] })
    end

    if params[:member_id].present?
      scope = scope.joins(:booking).where(bookings: { member_id: params[:member_id] })
    end

    @check_ins = scope.order(checked_in_at: :desc).all
    render json: @check_ins, include: { booking: { include: { member: {}, schedule: { include: [:course, :coach] } } } }
  end

  def show
    @check_in = CheckIn.includes(booking: { member: {}, schedule: [:course, :coach] }).find(params[:id])
    render json: @check_in, include: { booking: { include: { member: {}, schedule: { include: [:course, :coach] } } } }
  end

  def create
    if params[:booking_id].present?
      @check_in = CheckIn.new(check_in_params)
    elsif params[:member_id].present? && params[:schedule_id].present?
      booking = Booking.where(member_id: params[:member_id], schedule_id: params[:schedule_id])
                       .where.not(status: Booking.statuses[:cancelled])
                       .first

      unless booking
        return render json: { error: CheckIn::BOOKING_NOT_FOUND_CODE, message: '未找到该会员在此课程的预约' }, status: :not_found
      end

      @check_in = CheckIn.new(booking: booking)
    else
      return render json: { error: 'BAD_REQUEST', message: '需要提供 booking_id 或 member_id + schedule_id' }, status: :bad_request
    end

    if @check_in.save
      render json: @check_in, include: { booking: { include: { member: {}, schedule: { include: [:course, :coach] } } } }, status: :created, location: @check_in
    else
      error_code = @check_in.errors[:base].first || 'VALIDATION_ERROR'
      render json: {
        error: error_code,
        message: @check_in.errors.full_messages.join(', '),
        details: @check_in.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def check_in_params
    params.permit(:booking_id, :checked_in_at)
  end
end
