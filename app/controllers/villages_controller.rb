class VillagesController < ApplicationController
  before_action :set_village, only: [:show, :edit, :update, :destroy]

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
    @village = Village.new(village_params)

    if @village.save
      redirect_to @village, notice: 'Village was successfully created.'
    else
      render :new
    end
  end

  def update
    if @village.update(village_params)
      redirect_to @village, notice: 'Village was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /villages/1
  # DELETE /villages/1.json
  def destroy
    @village.destroy
    redirect_to villages_url, notice: 'Village was successfully destroyed.'
  end

  private

  def set_village
    @village = Village.find(params[:id])
  end

  def village_params
    params.require(:village).permit(:user_id, :name, :player_num, :start_time, :discussion_time)
  end
end
