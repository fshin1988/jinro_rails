require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { create(:player) }
  it 'has a valid factory' do
    expect(player).to be_valid
  end

  context 'when player is human' do
    it 'returns true' do
      player = create(:player, role: 'villager')
      expect(player.human?).to be_truthy
    end
  end

  context 'when player is werewolf' do
    it 'returns false' do
      player = create(:player, role: 'werewolf')
      expect(player.human?).to be_falsey
    end
  end
end
