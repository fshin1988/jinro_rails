class Api::V1::VillagesController < ApplicationController
  include VillagesHelper

  before_action :set_village

  def remaining_time
    render json: {remaining_time: @village.remaining_time}, status: 200
  end

  def proceed
    if @village.next_update_time <= Time.now
      noon_process
      night_process
      ReloadBroadcastJob.perform_later(@village)
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
    @village.update_divined_player_of_result
    @village.update_guarded_player_of_result
    @village.room_for_all.posts.create!(content: noon_message(@village), day: @village.day, owner: :system)
    end_process
  end

  def night_process
    return if @village.ended?
    @village.attack
    @village.room_for_all.posts.create!(content: night_message(@village), day: @village.day, owner: :system)
    return if end_process
    proceed_to_next_day
  end

  def proceed_to_next_day
    @village.update!(day: @village.day + 1, next_update_time: Time.now + @village.discussion_time.minutes)
    @village.prepare_records
    @village.prepare_result
    @village.room_for_all.posts.create!(content: morning_message(@village), day: @village.day, owner: :system)
  end

  def end_process
    case @village.judge_end
    when :werewolf_win
      @village.update!(status: :ended, winner: :werewolf_win)
      create_end_message
    when :human_win
      @village.update!(status: :ended, winner: :human_win)
      create_end_message
    else
      false
    end
  end

  def create_end_message
    @village.room_for_all.posts.create!(content: end_message(@village), day: @village.day, owner: :system)
    @village.room_for_all.posts.create!(content: reveal_message(@village), day: @village.day, owner: :system)
  end

  def set_village
    @village = Village.find(params[:id])
  end
end
