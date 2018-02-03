class VillagesController < ApplicationController
  include VillagesHelper

  skip_before_action :authenticate_user!, only: :index
  before_action :set_village, only: %i[edit update destroy join exit start ruin]
  before_action :authorize_village, only: %i[index new create]

  def index
    villages =
      if params[:filter] == "ended"
        @filter = "ended"
        Village.where(status: %w[ended ruined])
      else
        Village.where(status: %w[not_started in_play])
      end
    @villages = villages.order("created_at DESC").page params[:page]
  end

  def new
    @village = Village.new
  end

  def edit
  end

  def create
    @village = current_user.villages.new(village_params)

    if @village.save
      redirect_to villages_path, notice: "#{@village.name} が作成されました"
    else
      render :new
    end
  end

  def update
    if @village.update(village_params)
      @village.post_system_message(update_message(@village))
      redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @village.destroy
    redirect_to villages_url, notice: "#{@village.name} が削除されました"
  end

  def ruin
    if @village.update(status: :ruined)
      @village.post_system_message(ruin_message(@village))
      ReloadBroadcastJob.perform_later(@village)
      redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} が廃村になりました"
    else
      render :edit
    end
  end

  def start
    @village.assign_role
    @village.update_to_next_day
    @village.update(status: :in_play)
    @village.post_system_message(start_message(@village))
    ReloadBroadcastJob.perform_later(@village)
    redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} を開始しました"
  end

  private

  def set_village
    @village = Village.find(params[:id])
    authorize @village
  end

  def authorize_village
    authorize Village
  end

  def village_params
    params.require(:village).permit(:name, :player_num, :discussion_time, :first_day_victim, :start_at, :show_vote_target)
  end
end
