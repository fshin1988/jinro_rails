class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room:room_channel_#{params[:room_id]}"
    @room = Room.find params[:room_id]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    player = Player.find data['player_id'].to_i
    post = Post.create!(player: player, room: @room, content: data['message'], day: @room.village.day)
  end
end
