class ReloadBroadcastJob < ApplicationJob
  queue_as :default

  def perform(village)
    ActionCable.server.broadcast "room:room_channel_#{village.room_for_all.id}", reload: true
    ActionCable.server.broadcast "room:room_channel_#{village.room_for_wolf.id}", reload: true
  end
end
