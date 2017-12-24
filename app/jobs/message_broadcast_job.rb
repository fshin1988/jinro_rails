class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(post)
    RoomChannel.broadcast_to("room_channel_#{post.room_id}", message: render_post(post))
  end

  private

  def render_post(post)
    ApplicationController.renderer.new.render(partial: 'posts/post', locals: {post: post})
  end
end
