require 'rails_helper'

RSpec.describe Village, type: :model do
  let(:village) { create(:village) }
  it 'has a valid factory' do
    expect(village).to be_valid
  end

  context 'when player_num is 5(minimum)' do
    it 'assigns role to players' do
      village = create(:village_with_player, player_num: 5)

      village.assign_role
      expect(village.players.map(&:role)).to match_array Settings.role_list[5]
    end
  end

  context 'when player_num is 16(maximum)' do
    it 'assigns role to players' do
      village = create(:village_with_player, player_num: 16)

      village.assign_role
      expect(village.players.map(&:role)).to match_array Settings.role_list[16]
    end
  end

  it 'excludes the most voted player' do
    village = create(:village_with_player, player_num: 13)
    voted_player = village.players.first
    village.players.each do |p|
      create(:record, village: village, player: p, vote_target: voted_player)
    end

    village.lynch
    voted_player.reload
    expect(voted_player.status).to eq 'dead'
  end
end
