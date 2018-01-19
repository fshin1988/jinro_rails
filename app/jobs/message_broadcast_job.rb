class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(post)
    RoomChannel.broadcast_to("room_channel_#{post.room_id}", message: PostSerializer.new(post).to_json)
  end
end
