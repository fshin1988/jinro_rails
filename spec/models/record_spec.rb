require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:user) { create(:user) }
  let(:player) { create(:player, user: user) }
  let(:record) { create(:record, player: player, vote_target: player) }
  it 'has a valid factory' do
    expect(record).to be_valid
  end
end
