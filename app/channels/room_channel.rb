class RoomChannel < ApplicationCable::Channel
  include Pundit

  def subscribed
    stream_from "room:room_channel_#{params[:room_id]}"
    @room = Room.find params[:room_id]
  end

  def speak(data)
    authorize @room, :speak?
    player = @room.village.player_from_user(current_user)
    @room.posts.create!(player: player, content: data['message'], day: @room.village.day)
  end
end
