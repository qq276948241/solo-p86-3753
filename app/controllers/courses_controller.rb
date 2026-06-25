class CoursesController < ApplicationController
  def index
    @courses = Course.all.order(created_at: :desc)
    render json: @courses
  end

  def show
    @course = Course.find(params[:id])
    render json: @course
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      render json: @course, status: :created, location: @course
    else
      render json: { error: 'VALIDATION_ERROR', details: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      render json: @course
    else
      render json: { error: 'VALIDATION_ERROR', details: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @course = Course.find(params[:id])
    if @course.destroy
      head :no_content
    else
      render json: { error: 'DELETE_FAILED', details: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :duration_minutes)
  end
end
