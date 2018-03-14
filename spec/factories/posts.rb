FactoryBot.define do
  factory :post do
    association :player
    association :room
    content 'はじめまして!'
    day 1
  end
end
