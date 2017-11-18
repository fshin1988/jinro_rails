class VillagesController < ApplicationController
  before_action :set_village, only: [:show, :edit, :update, :destroy, :join, :exit]
  before_action :authorize_village, only: [:index, :new, :create]

  def index
    @villages = Village.all
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
    redirect_to village_room_path(@village, @village.rooms.for_all.first), notice: "#{@village.name} に参加しました"
  end

  def exit
    @village.exclude_player(current_user)
    redirect_to villages_path, notice: "#{@village.name} から退出しました"
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
