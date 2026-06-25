class BookingsController < ApplicationController
  def index
    scope = Booking.includes(:member, schedule: [:course, :coach])

    if params[:member_id].present?
      scope = scope.where(member_id: params[:member_id])
    end

    if params[:schedule_id].present?
      scope = scope.where(schedule_id: params[:schedule_id])
    end

    if params[:status].present?
      scope = scope.where(status: params[:status])
    end

    scope = scope.where.not(status: Booking.statuses[:cancelled]) if params[:active] == 'true'

    @bookings = scope.order(created_at: :desc).all
    render json: @bookings, include: { member: {}, schedule: { include: [:course, :coach] } }
  end

  def show
    @booking = Booking.includes(:member, schedule: [:course, :coach], check_in: {}).find(params[:id])
    render json: @booking, include: { member: {}, schedule: { include: [:course, :coach] }, check_in: {} }
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      render json: @booking, include: { member: {}, schedule: { include: [:course, :coach] } }, status: :created, location: @booking
    else
      error_code = @booking.errors[:base].first || 'VALIDATION_ERROR'
      render json: {
        error: error_code,
        message: @booking.errors.full_messages.join(', '),
        details: @booking.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def cancel
    @booking = Booking.find(params[:id])

    result = @booking.cancel!
    if result == true
      render json: @booking, include: { member: {}, schedule: { include: [:course, :coach] } }
    else
      error_code = @booking.errors[:base].first || 'CANCEL_FAILED'
      render json: {
        error: error_code,
        message: @booking.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.cancel!
    head :no_content
  end

  private

  def booking_params
    params.require(:booking).permit(:member_id, :schedule_id)
  end
end
