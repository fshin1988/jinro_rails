FactoryGirl.define do
  factory :player do
    association :user
    association :village
    role :villager
    status :alive
  end
end
