class Api::V1::VillagesController < ApplicationController
  before_action :set_village

  def remaining_time
    render json: {remaining_time: @village.remaining_time}, status: 200
  end

  def go_next_day
    @village.lynch
    if @village.judge_end == 0
      @village.attack
      @village.judge_end
    end
    head :ok
  end

  private

  def set_village
    @village = Village.find(params[:id])
  end
end
