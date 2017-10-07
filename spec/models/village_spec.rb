require 'rails_helper'

RSpec.describe Village, type: :model do
  let(:village) { create(:village) }
  it 'has a valid factory' do
    expect(village).to be_valid
  end

  context 'when player_num is 10' do
    it 'assign role to players' do
      village = create(:village, player_num: 10)
      10.times do |i|
        create(:player, village: village)
      end

      village.assign_role
      roles = [['villager']*6, ['werewolf']*2, ['fortune_teller']*1, ['psychic']*1].flatten
      expect(village.players.map(&:role)).to match_array roles
    end
  end
end
