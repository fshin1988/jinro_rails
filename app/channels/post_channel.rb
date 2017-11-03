class PostChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'post:post_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    post = Post.create!(player_id: 1, room_id: 1, content: data['message'], day: 0)
    PostChannel.broadcast_to('post_channel', message: render_post(post))
  end

  private

  def render_post(post)
    ApplicationController.renderer.render(partial: 'posts/post', locals: {post: post})
  end
end
