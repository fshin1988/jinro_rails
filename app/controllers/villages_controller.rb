class VillagesController < ApplicationController
  before_action :set_village, only: %i[edit update destroy join exit start]
  before_action :authorize_village, only: %i[index new create]

  def index
    @villages = Village.all
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
      redirect_to villages_path, notice: "#{@village.name} が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @village.destroy
    redirect_to villages_url, notice: "#{@village.name} が削除されました"
  end

  def join
    @village.create_player(current_user)
    redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} に参加しました"
  end

  def exit
    @village.make_player_exit(current_user)
    redirect_to villages_path, notice: "#{@village.name} から退出しました"
  end

  def start
    @village.update!(day: 1, status: :in_play, next_update_time: Time.now + @village.discussion_time.minutes)
    @village.assign_role
    @village.prepare_records
    @village.prepare_result
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
    params.require(:village).permit(:name, :player_num, :discussion_time)
  end
end
