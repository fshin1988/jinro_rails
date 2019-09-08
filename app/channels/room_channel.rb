class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room:room_channel_#{params[:room_id]}"
    @room = Room.find params[:room_id]
  end
end
