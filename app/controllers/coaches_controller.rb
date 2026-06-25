class CoachesController < ApplicationController
  def index
    @coaches = Coach.all.order(created_at: :desc)
    render json: @coaches
  end

  def show
    @coach = Coach.find(params[:id])
    render json: @coach
  end

  def create
    @coach = Coach.new(coach_params)
    if @coach.save
      render json: @coach, status: :created, location: @coach
    else
      render json: { error: 'VALIDATION_ERROR', details: @coach.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @coach = Coach.find(params[:id])
    if @coach.update(coach_params)
      render json: @coach
    else
      render json: { error: 'VALIDATION_ERROR', details: @coach.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @coach = Coach.find(params[:id])
    if @coach.destroy
      head :no_content
    else
      render json: { error: 'DELETE_FAILED', details: @coach.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def coach_params
    params.require(:coach).permit(:name, :phone, :bio)
  end
end
