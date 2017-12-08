class Api::V1::RecordsController < ApplicationController
  before_action :set_record

  def update
    if @record.update(record_params)
      head :ok
    else
      head :bad_request
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
