class Api::V1::RecordsController < ApplicationController
  before_action :set_record, only: :update

  def index
    records = Record.where(village_id: params[:village])
    render json: records
  end

  def update
    if @record.update(record_params)
      render json: @record, status: 200
    else
      render json: {error: @record.errors}, status: 422
    end
  end

  private

  def set_record
    @record = Record.find(params[:id])
    authorize @record
  end

  def record_params
    params.require(:record).permit(:vote_target_id, :attack_target_id, :divine_target_id, :guard_target_id)
  end
end
