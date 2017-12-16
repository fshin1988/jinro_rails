# Admin User
admin = FactoryGirl.create(:user, role: :admin, email: 'admin@example.co.jp', username: 'admin', confirmed_at: Time.now)

# Village for pagination test
10.times do |num|
  FactoryGirl.create(:village, name: "テスト村#{num + 1}", user: admin, player_num: 5,
                               day: 0, status: :not_started)
end

# Create after sleeping 1 seconds for displaying this village first in villages index
sleep(1)
village = FactoryGirl.create(:village, user: admin, player_num: 13,
                                       day: 0, status: :not_started)

user_names = %w[ヴァルター モーリッツ ジムゾン トーマス ニコラス ディーター
                ペーター アルビン カタリナ オットー ヨアヒム ヤコブ フリーデル]
13.times do
  user = FactoryGirl.create(:user, confirmed_at: Time.now, username: user_names.pop)
  FactoryGirl.create(:player, user: user, village: village)
end
