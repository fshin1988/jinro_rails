class Api::V1::VillagesController < ApplicationController
  before_action :set_village

  def remaining_time
    render json: {remaining_time: @village.remaining_time}, status: 200
  end

  def go_next_day
    if @village.next_update_time <= Time.now
      @village.lynch
      if @village.judge_end == 0
        @village.attack
        @village.judge_end
        if @village.judge_end == 0
          @village.update!(day: @village.day + 1, next_update_time: Time.now + @village.discussion_time.minutes)
        end
      end
      head :ok
    else
      head :unauthorized
    end
  end

  private

  def set_village
    @village = Village.find(params[:id])
  end
end
