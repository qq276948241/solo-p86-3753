class SchedulesController < ApplicationController
  def index
    scope = Schedule.includes(:course, :coach)

    if params[:week_date].present?
      date = Date.parse(params[:week_date])
      scope = scope.for_week(date)
    elsif params[:this_week] == 'true'
      scope = scope.this_week
    elsif params[:upcoming] == 'true'
      scope = scope.upcoming
    else
      scope = scope.order(start_time: :desc)
    end

    @schedules = scope.all
    render json: @schedules, include: [:course, :coach], methods: [:remaining_slots, :full?, :expired?]
  end

  def show
    @schedule = Schedule.includes(:course, :coach, active_bookings: [:member]).find(params[:id])
    render json: @schedule,
           include: {
             course: {},
             coach: {},
             active_bookings: { include: :member }
           },
           methods: [:remaining_slots, :full?, :expired?, :end_time]
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      render json: @schedule, include: [:course, :coach], status: :created, location: @schedule
    else
      render json: { error: 'VALIDATION_ERROR', details: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @schedule = Schedule.find(params[:id])
    if @schedule.update(schedule_params)
      render json: @schedule, include: [:course, :coach]
    else
      render json: { error: 'VALIDATION_ERROR', details: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    if @schedule.destroy
      head :no_content
    else
      render json: { error: 'DELETE_FAILED', details: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def batch_create
    schedules_params = params.require(:schedules)
    schedules = schedules_params.map do |sp|
      Schedule.new(sp.permit(:course_id, :coach_id, :start_time, :capacity))
    end

    Schedule.transaction do
      schedules.each(&:save!)
    end

    render json: schedules, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: 'BATCH_CREATE_FAILED', message: e.message, details: schedules.select { |s| !s.errors.empty? }.map { |s| { schedule: s.attributes, errors: s.errors.full_messages } } }, status: :unprocessable_entity
  end

  private

  def schedule_params
    params.require(:schedule).permit(:course_id, :coach_id, :start_time, :capacity)
  end
end
