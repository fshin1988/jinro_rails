require 'rails_helper'

RSpec.describe BlacklistUser, type: :model do
  it 'has a valid factory' do
    blacklist_user = build(:blacklist_user)
    expect(blacklist_user).to be_valid
  end
end
