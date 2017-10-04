FactoryGirl.define do
  factory :post do
    association :player
    association :room
    content 'はじめまして!'
  end
end
