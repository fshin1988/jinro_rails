class VillagesController < ApplicationController
  include VillagesHelper

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_village, only: %i[show edit update destroy start ruin]
  before_action :authorize_village, only: %i[index new create]

  def index
    villages =
      if params[:filter] == "ended"
        @filter = "ended"
        Village.where(status: %w[ended ruined])
      else
        Village.where(status: %w[not_started in_play])
      end
    @villages = villages.order("updated_at DESC").page params[:page]
    ActiveRecord::Precounter.new(@villages).precount(:players)
  end

  def show
  end

  def new
    @village = Village.new
  end

  def edit
  end

  def create
    @village = current_user.villages.new(village_params)

    if @village.save
      # TweetVillageJob.perform_later(@village)
      redirect_to villages_path, notice: "#{@village.name} が作成されました"
    else
      render :new
    end
  end

  def update
    if @village.update(village_params)
      @village.post_system_message(update_message(@village))
      redirect_to village_path(@village), notice: "#{@village.name} が更新されました"
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
      redirect_to village_path(@village), notice: "#{@village.name} が廃村になりました"
    else
      render :edit
    end
  end

  def start
    @village.with_lock do
      @village.start!
    end
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
    params.require(:village).permit(
      :name, :player_num, :discussion_time, :start_at,
      :show_vote_target, :access_password
    )
  end
end
