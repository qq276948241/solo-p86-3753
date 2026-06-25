class MembersController < ApplicationController
  def index
    @members = Member.all.order(created_at: :desc)
    render json: @members
  end

  def show
    @member = Member.find(params[:id])
    render json: @member
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      render json: @member, status: :created, location: @member
    else
      render json: { error: 'VALIDATION_ERROR', details: @member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      render json: @member
    else
      render json: { error: 'VALIDATION_ERROR', details: @member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @member = Member.find(params[:id])
    if @member.destroy
      head :no_content
    else
      render json: { error: 'DELETE_FAILED', details: @member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :phone, :status, :member_since)
  end
end
