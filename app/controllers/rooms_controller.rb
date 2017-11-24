class RoomsController < ApplicationController
  before_action :set_room, only: :show
  before_action :color_of_navbar

  def show
  end

  private

  def set_room
    @room = Room.find(params[:id])
    authorize @room
    @village = @room.village
  end

  def color_of_navbar
    if @room.for_wolf?
      @color_of_navbar = 'black'
    else
      @color_of_navbar = 'red'
    end
  end
end
