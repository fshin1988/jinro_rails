class ProceedVillageJob < ApplicationJob
  include VillagesHelper

  queue_as :default

  def perform(village)
    @village = village
    noon_process
    night_process
    proceed_to_next_day
    ReloadBroadcastJob.perform_later(@village)
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
end
