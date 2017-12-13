class Api::V1::VillagesController < Api::V1::ApiController
  include VillagesHelper

  before_action :set_village

  def remaining_time
    render json: {remaining_time: @village.remaining_time}, status: 200
  end

  def proceed
    @village.with_lock do
      if @village.next_update_time <= Time.now
        noon_process
        night_process
        proceed_to_next_day
        ReloadBroadcastJob.perform_later(@village)
      end
    end
    head :ok
  end

  def divine
    render json: {messages: messages_of_result(@village.divine_results)}, status: 200
  end

  def see_soul
    render json: {messages: messages_of_result(@village.vote_results)}, status: 200
  end

  private

  def noon_process
    @village.lynch
    @village.update_results
    @village.post_system_message(noon_message(@village))
    end_process
  end

  def night_process
    return if @village.ended?
    @village.attack
    @village.post_system_message(night_message(@village))
    end_process
  end

  def proceed_to_next_day
    return if @village.ended?
    @village.update_to_next_day
    @village.post_system_message(morning_message(@village))
  end

  def end_process
    case @village.judge_end
    when :werewolf_win
      @village.update!(status: :ended, winner: :werewolf_win)
      create_end_message
    when :human_win
      @village.update!(status: :ended, winner: :human_win)
      create_end_message
    end
  end

  def create_end_message
    @village.post_system_message(end_message(@village))
    @village.post_system_message(reveal_message(@village))
  end

  def set_village
    @village = Village.find(params[:id])
    authorize @village
  end
end
