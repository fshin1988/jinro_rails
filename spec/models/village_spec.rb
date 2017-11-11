require 'rails_helper'

RSpec.describe Village, type: :model do
  let(:village) { create(:village) }

  it 'has a valid factory' do
    expect(village).to be_valid
  end

  describe '#assign_role' do
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
  end

  it 'excludes the most voted player' do
    village = create(:village_with_player, player_num: 13, day: 1)
    voted_player = village.players.first
    village.players.each do |p|
      create(:record, village: village, player: p, day: 1, vote_target: voted_player)
    end

    village.lynch
    voted_player.reload
    expect(voted_player.status).to eq 'dead'
  end

  it 'excludes the most attacked player' do
    village = create(:village_with_player, player_num: 13, day: 1)
    village.assign_role
    attacked_player = village.players.villager.first
    village.players.werewolf.each do |w|
      create(:record, village: village, player: w, day: 1, attack_target: attacked_player)
    end

    village.attack
    attacked_player.reload
    expect(attacked_player.status).to eq 'dead'
  end

  context 'if attacked player is same with guarded player' do
    it 'does not exclude the most attacked player' do
      village = create(:village_with_player, player_num: 13, day: 1)
      village.assign_role
      attacked_player = village.players.villager.first
      village.players.werewolf.each do |w|
        create(:record, village: village, player: w, day: 1, attack_target: attacked_player)
      end
      bodyguard = village.players.bodyguard.first
      create(:record, village: village, player: bodyguard, day: 1, guard_target: attacked_player)

      village.attack
      attacked_player.reload
      expect(attacked_player.status).to eq 'alive'
    end
  end

  describe '#judge_end' do
    context 'when the number of villagers is larger than the number of werewolves' do
      it 'returns 0' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.select(&:human?).sample(3).each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to eq 0
      end
    end

    context 'when all werewolves are dead' do
      it 'returns 1' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.werewolf.each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to eq 1
      end
    end

    context 'when the number of villagers is same with the number of werewolves' do
      it 'returns 2' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.select(&:human?).sample(4).each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to eq 2
      end
    end

    context 'when the number of villagers is less than the number of werewolves' do
      it 'returns 2' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.select(&:human?).sample(5).each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to be 2
      end
    end
  end

  context 'when start_time is after the current time' do
    it 'is valid' do
      now = Time.now
      Timecop.freeze(now) do
        village = build(:village, start_time: now + 1.seconds)
        expect(village).to be_valid
      end
    end
  end

  context 'when start_time is after the current time' do
    it 'is invalid' do
      now = Time.now
      Timecop.freeze(now) do
        village = build(:village, start_time: now - 1.seconds)
        expect(village).to be_invalid
      end
    end
  end

  context 'after create' do
    it 'creates two rooms' do
      village = build(:village)
      village.save
      expect(village.rooms.count).to be 2
    end
  end

  describe '#create_player' do
    it 'creates a player' do
      user = create(:user)
      village.create_player(user)
      expect(user.players.where(village: village)).not_to be_nil
    end
  end
end
