class PlayersController < ApplicationController
  include VillagesHelper

  before_action :set_player, only: %i[edit update destroy]

  def new
    @player = Player.new(village_id: params[:village_id], username: current_user.username)
    authorize @player
  end

  def edit
  end

  def create
    @player = current_user.players.new(player_params)
    authorize @player

    if @player.save
      @village = @player.village
      @village.post_system_message(join_message(@village, @player))
      notify_ready_to_start if @village.players.count == @village.player_num
      redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} に参加しました"
    else
      render :new
    end
  end

  def update
    if @player.update(player_params)
      redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@player.username} を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @player.update!(village_id: 0)
    @village.post_system_message(exit_message(@player))
    redirect_to villages_path, notice: "#{@village.name} から退出しました"
  end

  private

  def set_player
    @player = Player.find(params[:id])
    @village = @player.village
    authorize @player
    p @player.attributes
  end

  def player_params
    params.require(:player).permit(:village_id, :username, :avatar)
  end

  def notify_ready_to_start
    @village.post_system_message(ready_to_start_message)
    ReloadBroadcastJob.perform_later(@village)
  end
end
