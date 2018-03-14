FactoryBot.define do
  factory :result do
    association :village
    day 1
    association :voted_player, factory: :player
  end
end
