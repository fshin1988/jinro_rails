class PostChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'post:message'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def put_message(data)
    Post.create!(player_id: 1, room_id: 1, content: data['message'], day: 0)
    PostChannel.broadcast_to('message', data['message'])
  end
end
