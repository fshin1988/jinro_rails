# Admin User
admin = FactoryGirl.create(:confirmed_user, role: :admin, email: 'admin@example.co.jp', username: 'admin')

# Village
village = FactoryGirl.create(:village, user: admin, player_num: 13,
                                       day: 0, start_time: Time.now + 1.hours, status: :not_started)

# Room
room_for_all = FactoryGirl.create(:room, village: village, room_type: :for_all)
room_for_wolf = FactoryGirl.create(:room, village: village, room_type: :for_wolf)

# Normal User
13.times do
  user = FactoryGirl.create(:user)
  player = FactoryGirl.create(:player, user: user, village: village)
  # Post
  FactoryGirl.create(:post, player: player, room: room_for_all, content: "Hello, I'm #{user.username}", day: 0)
end
