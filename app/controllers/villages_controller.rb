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
      redirect_to villages_path, notice: 'Village was successfully created.'
    else
      render :new
    end
  end

  def update
    if @village.update(village_params)
      redirect_to villages_path, notice: 'Village was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @village.destroy
    redirect_to villages_url, notice: 'Village was successfully destroyed.'
  end

  def join
    @village.create_player(current_user)
    redirect_to village_room_path(@village, @village.rooms.for_all.first), notice: 'You joined the village.'
  end

  def exit
    @village.exclude_player(current_user)
    redirect_to villages_path, notice: 'You exited from the village.'
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
