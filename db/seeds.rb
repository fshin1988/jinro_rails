# Admin User
admin = FactoryBot.create(:user, role: :admin, email: 'admin@example.co.jp', username: 'admin', confirmed_at: Time.now)

# Village for pagination test
60.times do |num|
  FactoryBot.create(:village, name: "テスト村#{num + 1}", user: admin, player_num: 5,
                               day: 0, status: :not_started)
end

# Create after sleeping 1 seconds for displaying this village first in villages index
sleep(1)
village = FactoryBot.create(:village, user: admin, player_num: 13,
                                       day: 0, status: :not_started)

user_names = %w[ヴァルター モーリッツ ジムゾン トーマス ニコラス ディーター
                ペーター アルビン カタリナ オットー ヨアヒム ヤコブ フリーデル]
13.times do
  user = FactoryBot.create(:user, confirmed_at: Time.now, username: user_names.pop)
  FactoryBot.create(:player, user: user, village: village, username: user.username)
end

# Create player for a village which player_num is 5 for test
village = Village.find_by(player_num: 5)
User.limit(5).each do |user|
  FactoryBot.create(:player, user: user, village: village, username: user.username)
end

FactoryBot.create(:manual, content: "#マニュアル")
