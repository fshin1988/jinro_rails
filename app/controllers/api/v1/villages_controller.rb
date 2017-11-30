class Api::V1::VillagesController < ApplicationController
  before_action :set_village

  def remaining_time
    render json: {remaining_time: @village.remaining_time}, status: 200
  end

  def go_next_day
    if @village.next_update_time <= Time.now
      noon_process
      night_process
      ActionCable.server.broadcast "room:room_channel_#{@village.room_for_all.id}", reload: true
      ActionCable.server.broadcast "room:room_channel_#{@village.room_for_wolf.id}", reload: true
    end
    head :ok
  end

  def divine
    render json: {messages: view_context.divine_messages(@village.divine_results(current_user))}, status: 200
  end

  def see_soul
  end

  private

  def noon_process
    excluded_player = @village.lynch
    @village.results.find_by(day: @village.day).update(voted_player: excluded_player)
    @village.update_divined_player_of_result
    @village.update_guarded_player_of_result
    case @village.judge_end
    when 2
      @village.update!(status: :ended)
    when 1
      @village.update!(status: :ended)
    else
      false
    end
  end

  def night_process
    return if @village.ended?
    excluded_player = @village.attack
    @village.results.find_by(day: @village.day).update(attacked_player: excluded_player)
    case @village.judge_end
    when 2
      @village.update!(status: :ended)
    when 1
      @village.update!(status: :ended)
    else
      @village.update!(day: @village.day + 1, next_update_time: Time.now + @village.discussion_time.minutes)
      @village.prepare_records
      @village.prepare_result
    end
  end

  def set_village
    @village = Village.find(params[:id])
  end
end
