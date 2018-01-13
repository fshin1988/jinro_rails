class Villages::KicksController < ApplicationController
  include VillagesHelper

  before_action :set_village, only: %i[edit update]

  def edit
  end

  def update
    player = Player.find_by(id: player_params[:id])
    if player
      @village.kick_player(player)
      @village.post_system_message(kick_message(player))
      ReloadBroadcastJob.perform_later(@village)
      redirect_to village_room_path(@village, @village.room_for_all), notice: "#{player.username} をキックしました"
    else
      redirect_to edit_village_kick_path(@village), notice: "プレイヤーが選択されていません"
    end
  end

  private

  def set_village
    @village = Village.find(params[:village_id])
    authorize @village, :kick?
  end

  def player_params
    params.require(:player).permit(:id)
  end
end
