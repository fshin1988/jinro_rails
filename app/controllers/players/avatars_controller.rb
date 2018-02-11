class Players::AvatarsController < ApplicationController
  before_action :set_player, only: %i[edit update]
  before_action :check_params, only: :update

  def edit
  end

  def update
    if @player.update(player_params)
      redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@player.username} を更新しました"
    else
      render :edit
    end
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
    @village = @player.village
    authorize @player
  end

  def player_params
    params.require(:player).permit(:avatar)
  end

  def check_params
    return if params[:player][:avatar].present?
    @player.errors.add(:base, "プロフィール画像を選択してください")
    render :edit
  end
end
