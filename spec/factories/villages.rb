FactoryGirl.define do
  factory :village do
    association :user
    name '初心者村'
    player_num 13
    day 1
    start_time Time.now + 1.hours
    discussion_time 10
    status :in_play

    factory :village_with_player do
      after(:create) do |v|
        v.player_num.times do
          create(:player, village: v)
        end
      end
    end

    factory :invalid_village do
      name nil
    end
  end
end
