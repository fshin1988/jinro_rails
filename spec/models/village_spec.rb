require 'rails_helper'

RSpec.describe Village, type: :model do
  let(:village) { create(:village) }

  it 'has a valid factory' do
    expect(village).to be_valid
  end

  it 'is valid with access_password' do
    village.access_password = "12345"
    expect(village).to be_valid
  end

  it 'is invalid with access_password longer than 20 characters' do
    village.access_password = "123456789012345678901"
    expect(village).to be_invalid
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

  describe 'lynch' do
    it 'excludes the most voted player' do
      village = create(:village_with_player, player_num: 13, day: 0)
      village.assign_role
      village.update_to_next_day
      voted_player = village.players.first
      village.players.each do |p|
        create(:record, village: village, player: p, day: 1, vote_target: voted_player)
      end

      village.lynch
      voted_player.reload
      expect(voted_player.status).to eq 'dead'
      expect(village.results.find_by(day: 1).voted_player).to eq voted_player
    end

    context 'if all vote_target are not setted' do
      it 'excludes one player randomly' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role
        village.update_to_next_day
        village.players.each do |p|
          create(:record, village: village, player: p, day: 1, vote_target: nil)
        end

        village.lynch
        expect(village.players.alive.count).to eq 12
      end
    end
  end

  describe 'attack' do
    let(:village) { create(:village_with_player, player_num: 13, day: 0) }
    let(:attacked_player) { village.players.villager.first }

    before do
      village.assign_role
      village.update_to_next_day
    end

    it 'excludes the attacked player' do
      village.players.werewolf.each do |w|
        w.records.first.update(attack_target: attacked_player)
      end

      village.attack
      expect(attacked_player.reload.status).to eq 'dead'
      expect(village.results.find_by(day: 1).attacked_player).to eq attacked_player
    end

    context 'if there are multiple attacked players' do
      let(:last_attacked_player) { village.players.villager.last }

      before do
        village.players.werewolf.each do |w|
          w.records.first.update(attack_target: attacked_player)
        end
        village.players.werewolf.last.records.first.update(attack_target: last_attacked_player)
      end

      it 'excludes last attacked player' do
        village.attack
        expect(last_attacked_player.reload.status).to eq 'dead'
        expect(village.results.find_by(day: 1).attacked_player).to eq last_attacked_player
      end
    end

    context 'if all attack_target are not setted' do
      it 'excludes one human randomly' do
        village.attack
        expect(village.players.alive.select(&:human?).count).to eq 9
      end
    end

    context 'if attacked player is same with guarded player' do
      before do
        village.players.werewolf.each do |w|
          w.records.first.update(attack_target: attacked_player)
        end
        bodyguard = village.players.bodyguard.first
        bodyguard.records.first.update(guard_target: attacked_player)
      end

      it 'does not exclude the most attacked player' do
        village.attack
        expect(attacked_player.reload.status).to eq 'alive'
      end
    end

    context 'if bodyguard is voted player and attacked player is same with guarded player' do
      before do
        bodyguard = village.players.bodyguard.first
        village.players.each { |p| p.records.first.update(vote_target: bodyguard) }
        village.players.werewolf.each { |w| w.records.first.update(attack_target: attacked_player) }
        bodyguard.records.first.update(guard_target: attacked_player)
      end

      it 'exclude the most attacked player' do
        village.lynch
        village.attack
        expect(attacked_player.reload.status).to eq 'dead'
      end
    end
  end

  describe '#judge_end' do
    context 'when the number of villagers is larger than the number of werewolves' do
      it 'returns :continued' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.select(&:human?).sample(3).each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to eq :continued
      end
    end

    context 'when all werewolves are dead' do
      it 'returns :human_win' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.werewolf.each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to eq :human_win
      end
    end

    context 'when the number of villagers is same with the number of werewolves' do
      it 'returns :werewolf_win' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.select(&:human?).sample(4).each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to eq :werewolf_win
      end
    end

    context 'when the number of villagers is less than the number of werewolves' do
      it 'returns :werewolf_win' do
        village = create(:village_with_player, player_num: 8, day: 1)
        village.assign_role # villager:5, werewolf:2, fortune_teller:1
        village.players.select(&:human?).sample(5).each do |p|
          p.update(status: 'dead')
        end

        expect(village.judge_end).to be :werewolf_win
      end
    end
  end

  context 'after create' do
    it 'creates three rooms' do
      village = build(:village)
      village.save
      expect(village.rooms.count).to be 3
    end
  end

  describe '#player_from_user' do
    it 'returns a player of the user' do
      user = create(:user)
      create(:player, user: user, village: village)

      expect(village.player_from_user(user)).to eq village.players.find_by(user: user)
    end
  end

  describe '#make_player_exit' do
    it 'excludes a player of user' do
      user = create(:user)
      create(:player, user: user, village: village)
      village.make_player_exit(user)
      expect(village.players.where(user: user)).to be_empty
    end
  end

  describe '#kick_player' do
    it 'excludes the player and adds the user to blacklist' do
      user = create(:user)
      player = create(:player, user: user, village: village)
      village.kick_player(player)
      expect(village.players.where(user: user)).to be_empty
      expect(village.blacklist_users.find_by(user: user).user).to eq user
    end
  end

  describe '#update_to_next_day' do
    it 'update day to next day' do
      village = create(:village_with_player, player_num: 13, day: 1)
      village.update_to_next_day

      expect(village.day).to be 2
    end

    it 'update next_update_time' do
      Timecop.freeze
      now = Time.now
      village = create(:village_with_player, player_num: 13, day: 1, next_update_time: now)
      village.update_to_next_day

      expect(village.next_update_time).to be > now
      Timecop.return
    end

    describe '#prepare_records' do
      it 'creates reocrds for each players' do
        village = create(:village_with_player, player_num: 13, day: 1)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day

        expect(village.records.count).to be 13
      end

      context 'when there is dead player' do
        it 'creates records except dead player' do
          village = create(:village_with_player, player_num: 13, day: 1)
          village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
          dead_player = village.players.first
          dead_player.update(status: :dead)
          village.update_to_next_day

          expect(village.records.count).to be 12
        end
      end
    end

    describe '#prepare_result' do
      it 'preapre result record' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.update_to_next_day

        expect(village.results.where(day: 1)).not_to be_nil
      end
    end
  end

  describe '#update_results' do
    describe '#update_divined_player_of_result' do
      it 'updates divined_player of result' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        divined_player = village.players.villager.first
        fortune_teller = village.players.fortune_teller.first
        fortune_teller.records.first.update(divine_target: divined_player)
        village.update_results

        expect(village.results.find_by(day: 1).divined_player).to eq divined_player
      end
    end

    describe '#update_guarded_player_of_result' do
      it 'updates guarded_player of result' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        guarded_player = village.players.villager.first
        bodyguard = village.players.bodyguard.first
        bodyguard.records.first.update(guard_target: guarded_player)
        village.update_results

        expect(village.results.find_by(day: 1).guarded_player).to eq guarded_player
      end
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
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        divined_player = village.players.villager.first
        fortune_teller = village.players.fortune_teller.first
        fortune_teller.records.first.update(divine_target: divined_player)
        village.update_results

        expect(village.divine_results).to eq(divined_player.username => true)
      end
    end

    context 'when divined player is werewolf' do
      it 'returns username of divine_target_id and false' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        divined_player = village.players.werewolf.first
        fortune_teller = village.players.fortune_teller.first
        fortune_teller.records.first.update(divine_target: divined_player)
        village.update_results

        expect(village.divine_results).to eq(divined_player.username => false)
      end
    end

    context 'when divined player is multiple' do
      it 'returns multiple divine results' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        # first day
        village.update_to_next_day
        divined_player_human = village.players.villager.first
        fortune_teller = village.players.fortune_teller.first
        record = village.records.find_by(player: fortune_teller, day: village.day)
        record.update(divine_target: divined_player_human)
        village.update_results
        # second day
        village.update_to_next_day
        divined_player_wolf = village.players.werewolf.first
        record = village.records.find_by(player: fortune_teller, day: village.day)
        record.update(divine_target: divined_player_wolf)
        village.update_results

        result = {divined_player_human.username => true, divined_player_wolf.username => false}
        expect(village.divine_results).to eq result
      end
    end

    context 'when divine_target is nil' do
      it 'returns empty hash' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        fortune_teller = village.players.fortune_teller.first
        create(:record, village: village, player: fortune_teller, day: 1, divine_target: nil)
        village.update_results

        expect(village.divine_results).to eq({})
      end
    end
  end

  describe '#vote_results' do
    context 'when voted player is human' do
      it 'returns username and true' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        voted_player = village.players.select(&:human?).first
        village.players.each do |p|
          create(:record, village: village, player: p, day: 1, vote_target: voted_player)
        end
        village.lynch

        expect(village.vote_results).to eq(voted_player.username => true)
      end
    end

    context 'when voted player is werewolf' do
      it 'returns username and false' do
        village = create(:village_with_player, player_num: 13, day: 0)
        village.assign_role # villager:6, werewolf:3, fortune_teller:1, psychic:1, bodyguard:1, madman:1
        village.update_to_next_day
        voted_player = village.players.werewolf.first
        village.players.each do |p|
          create(:record, village: village, player: p, day: 1, vote_target: voted_player)
        end
        village.lynch

        expect(village.vote_results).to eq(voted_player.username => false)
      end
    end
  end

  describe '#post_system_message' do
    it 'creates post of room_for_all' do
      village = create(:village, day: 1)
      village.post_system_message("Hello world")

      expect(village.room_for_all.posts.count).to eq 1
    end
  end

  describe '#number_of_votes' do
    it 'returns the number of votes to each players' do
      village = create(:village_with_player, player_num: 13, day: 0)
      village.assign_role
      village.update_to_next_day
      voted_player = village.players.first
      village.players.each do |p|
        create(:record, village: village, player: p, day: 1, vote_target: voted_player)
      end

      village.lynch
      voted_player.reload
      expect(village.number_of_votes).to match_array({voted_player.username => 13})
    end
  end

  describe '#start!' do
    it 'assigns role to players' do
      village = create(:village_with_player, player_num: 5)

      village.start!
      expect(village.players.map(&:role)).to match_array Settings.role_list[5]
    end

    it 'updates status to in_play' do
      village = create(:village_with_player, player_num: 5)

      village.start!
      expect(village.status).to eq 'in_play'
    end

    it 'increments day' do
      village = create(:village_with_player, player_num: 5, day: 0)

      village.start!
      expect(village.day).to eq 1
    end

    context 'if status is not not_started' do
      it 'does not update status' do
        village = create(:village_with_player, player_num: 5, day: 0, status: :ended)

        village.start!
        expect(village.status).not_to eq 'in_play'
      end

      it 'does not increment day' do
        village = create(:village_with_player, player_num: 5, day: 0, status: :in_play)

        village.start!
        expect(village.day).not_to eq 1
      end
    end
  end
end
