FactoryBot.define do
  factory :village do
    association :user
    name { '初心者村' }
    player_num { 13 }
    day { 1 }
    discussion_time { 1 }

    factory :village_with_player do
      after(:create) do |v|
        v.player_num.times do
          create(:player, village: v)
        end
      end
    end

    factory :invalid_village do
      name { nil }
    end
  end
end
