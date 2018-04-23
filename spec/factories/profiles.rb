FactoryBot.define do
  factory :profile do
    association :user
    comment "MyText"
  end
end
