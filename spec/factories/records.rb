FactoryBot.define do
  factory :record do
    association :village
    association :player
    day { 1 }
    association :vote_target, factory: :player
  end
end
