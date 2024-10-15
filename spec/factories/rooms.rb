FactoryBot.define do
  factory :room do
    association :village
    room_type { :for_all }
  end
end
