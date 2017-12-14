class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room:room_channel_#{params[:room_id]}"
    @room = Room.find params[:room_id]
  end

  def speak(data)
    player = @room.village.player_from_user(current_user)
    @room.posts.create!(player: player, content: data['message'], day: @room.village.day)
  end
end
