class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def render_not_found(exception)
    render json: { error: 'NOT_FOUND', message: exception.message }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    error_codes = exception.record.errors.full_messages
    main_error = error_codes.find { |msg| Booking.constants.any? { |c| Booking.const_get(c) == msg } rescue false } ||
                 error_codes.find { |msg| CheckIn.constants.any? { |c| CheckIn.const_get(c) == msg } rescue false } ||
                 'VALIDATION_ERROR'

    render json: {
      error: main_error,
      message: exception.message,
      details: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: { error: 'BAD_REQUEST', message: exception.message }, status: :bad_request
  end

  def render_error(error_code, message, status = :unprocessable_entity)
    render json: { error: error_code, message: message }, status: status
  end
end
