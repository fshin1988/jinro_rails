# Admin User
admin = FactoryGirl.create(:confirmed_user, role: :admin, email: 'admin@example.co.jp', username: 'admin')

# Village
village = FactoryGirl.create(:village, user: admin, player_num: 13,
                                       day: 0, start_time: Time.now + 1.hours, status: :not_started)

# Normal User
13.times do
  user = FactoryGirl.create(:confirmed_user)
  FactoryGirl.create(:player, user: user, village: village)
end
