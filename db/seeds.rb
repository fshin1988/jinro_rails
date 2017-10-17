# Admin User
admin = FactoryGirl.create(:confirmed_user, role: :admin, email: 'admin@example.co.jp', username: 'admin')

# Village
village = FactoryGirl.create(:village, user: admin, player_num: 13,
                                       day: 0, start_time: Time.now + 1.hours, status: :not_started)

# Room
FactoryGirl.create(:room, village: village, room_type: :for_all)
FactoryGirl.create(:room, village: village, room_type: :for_wolf)

# Normal User
13.times do
  user = FactoryGirl.create(:user)
  FactoryGirl.create(:player, user: user, village: village)
end
