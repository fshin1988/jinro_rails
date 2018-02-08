class TweetVillageJob < ApplicationJob
  queue_as :default

  def perform(village)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.twitter_key
      config.consumer_secret     = Settings.twitter_secret
      config.access_token        = Settings.twitter_access_token
      config.access_token_secret = Settings.twitter_access_token_secret
    end
    client.update(message_for(village))
  end

  private

  def message_for(village)
    message = "【新しい村が作成されました】\n"
    message << "#{village.name}\n開始予定: #{village.start_at.strftime('%-m/%-d %H:%M')}\n人数: #{village.player_num}人\n"
    message << "#{room_url(village)}\n\n"
    message << "#人狼 #募集"
  end

  def room_url(village)
    routes = Rails.application.routes
    routes.default_url_options = {host: Settings.host_name, protocol: :https}
    routes.url_helpers.village_room_url(village, village.room_for_all)
  end
end
