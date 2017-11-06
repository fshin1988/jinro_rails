class PostChannel < ApplicationCable::Channel
  def subscribed
    stream_from "post:post_channel_#{params[:room_id]}"
    @room = Room.find params[:room_id]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    player = Player.find data['player_id'].to_i
    post = Post.create!(player: player, room: @room, content: data['message'], day: @room.village.day)
    PostChannel.broadcast_to("post_channel_#{params[:room_id]}", message: render_post(post))
  end

  private

  def render_post(post)
    ApplicationController.renderer.render(partial: 'posts/post', locals: {post: post})
  end
end
