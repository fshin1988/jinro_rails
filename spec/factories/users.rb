FactoryGirl.define do
  factory :user do
    email 'test@example.co.jp'
    username 'test_user'
    password 'test1234'
    password_confirmation 'test1234'
  end
end
