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

  context 'if all vote_target are not setted' do
    it 'excludes one player randomly' do
      village = create(:village_with_player, player_num: 13, day: 1)
      village.players.each do |p|
        create(:record, village: village, player: p, day: 1, vote_target: nil)
      end

      village.lynch
      expect(village.players.alive.count).to eq 12
    end
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

  context 'if all attack_target are not setted' do
    it 'excludes one human randomly' do
      village = create(:village_with_player, player_num: 13, day: 1)
      village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
      village.players.werewolf.each do |w|
        create(:record, village: village, player: w, day: 1, attack_target: nil)
      end

      village.attack
      expect(village.players.alive.select(&:human?).count).to eq 9
    end
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

  context 'after create' do
    it 'creates two rooms' do
      village = build(:village)
      village.save
      expect(village.rooms.count).to be 2
    end
  end

  describe '#create_player' do
    it 'creates a player of user' do
      user = create(:user)
      village.create_player(user)
      expect(user.players.where(village: village)).not_to be_nil
    end
  end

  describe '#player_from_user' do
    it 'returns a player of the user' do
      user = create(:user)
      village.create_player(user)

      expect(village.player_from_user(user)).to eq village.players.find_by(user: user)
    end
  end

  describe '#exclude_player' do
    it 'excludes a player of user' do
      user = create(:user)
      village.create_player(user)
      village.exclude_player(user)
      expect(village.players.where(user: user)).to be_empty
    end
  end

  describe '#prepare_records' do
    it 'creates reocrds for each players' do
      village = create(:village_with_player, player_num: 13, day: 1)
      village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
      village.prepare_records

      expect(village.records.count).to be 13
    end
  end

  describe '#room_for_all' do
    it 'returns a room for all' do
      village = build(:village)
      village.save
      expect(village.room_for_all).to eq village.rooms.for_all.first
    end
  end

  describe '#room_for_wolf' do
    it 'returns a room for wolf' do
      village = build(:village)
      village.save
      expect(village.room_for_wolf).to eq village.rooms.for_wolf.first
    end
  end

  describe '#divine_results' do
    context 'when divined player is human' do
      it 'returns username of divine_target_id and true' do
        village = create(:village_with_player, player_num: 13, day: 2)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        divined_player = village.players.villager.first
        fortune_teller = village.players.fortune_teller.first
        create(:record, village: village, player: fortune_teller, day: 1, divine_target: divined_player)

        expect(village.divine_results(fortune_teller.user)).to eq [{divined_player.username => true}]
      end
    end

    context 'when divined player is werewolf' do
      it 'returns username of divine_target_id and false' do
        village = create(:village_with_player, player_num: 13, day: 2)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        divined_player = village.players.werewolf.first
        fortune_teller = village.players.fortune_teller.first
        create(:record, village: village, player: fortune_teller, day: 1, divine_target: divined_player)

        expect(village.divine_results(fortune_teller.user)).to eq [{divined_player.username => false}]
      end
    end

    context 'when divined player is multiple' do
      it 'returns multiple divine results' do
        village = create(:village_with_player, player_num: 13, day: 3)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        divined_player_human = village.players.villager.first
        divined_player_wolf = village.players.werewolf.first
        fortune_teller = village.players.fortune_teller.first
        create(:record, village: village, player: fortune_teller, day: 1, divine_target: divined_player_human)
        create(:record, village: village, player: fortune_teller, day: 2, divine_target: divined_player_wolf)

        result = [{divined_player_human.username => true}, {divined_player_wolf.username => false}]
        expect(village.divine_results(fortune_teller.user)).to eq result
      end
    end
  end

end
