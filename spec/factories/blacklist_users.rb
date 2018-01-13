FactoryGirl.define do
  factory :blacklist_user do
    association :village
    association :user
  end
end
