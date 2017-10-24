class Api::V1::RoomsController < ApplicationController
  before_action :set_room, only: :show

  def index
    rooms = Room.where(village_id: params[:village])
    render json: rooms
  end

  def show
    render json: @room.posts
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end
end
