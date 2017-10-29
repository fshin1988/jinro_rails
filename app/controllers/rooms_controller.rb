class RoomsController < ApplicationController
  before_action :set_room, only: :show

  def show
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end
end
