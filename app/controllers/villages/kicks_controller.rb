class Villages::KicksController < ApplicationController
  include VillagesHelper

  before_action :set_village, only: :update

  def update
    player = @village.kick_player(Player.find(village_params[:player_id]))
    @village.post_system_message(kick_message(player))
    ReloadBroadcastJob.perform_later(@village)
    redirect_to village_room_path(@village, @village.room_for_all), notice: "#{player.username} をキックしました"
  end

  private

  def set_village
    @village = Village.find(params[:village_id])
    authorize @village
  end

  def village_params
    params.require(:village).permit(:player_id)
  end
end
