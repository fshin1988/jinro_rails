FactoryGirl.define do
  factory :village do
    name '初心者村'
    player_num 13
    start_time Time.now
    discussion_time 10
    status :in_play
  end
end
