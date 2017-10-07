FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.co.jp" }
    sequence(:username) { |n| "user#{n}" }
    password 'test1234'
    password_confirmation 'test1234'
  end
end
