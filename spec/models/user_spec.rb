require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'is invalid without username' do
    user.username = nil
    expect(user).to be_invalid
  end

  describe '#joining_in_village?' do
    context 'when the user is joining in the village of not_started' do
      it 'returns true' do
        village = create(:village_with_player, player_num: 5, status: :not_started)
        create(:player, user: user, village: village)

        expect(user.joining_in_village?).to be true
      end
    end

    context 'when the user is joining in the village of in_play' do
      it 'returns true' do
        village = create(:village_with_player, player_num: 5, status: :in_play)
        create(:player, user: user, village: village)

        expect(user.joining_in_village?).to be true
      end
    end

    context 'when the user is not joining in the village' do
      it 'returns false' do
        expect(user.joining_in_village?).to be false
      end
    end

    context 'when the user is joining in the village of ended' do
      it 'returns false' do
        village = create(:village_with_player, player_num: 5, status: :ended)
        create(:player, user: user, village: village)

        expect(user.joining_in_village?).to be false
      end
    end

    context 'when the user is joining in the village of ruined' do
      it 'returns false' do
        village = create(:village_with_player, player_num: 5, status: :ruined)
        create(:player, user: user, village: village)

        expect(user.joining_in_village?).to be false
      end
    end

    context 'when the user exited from the village of not_started' do
      it 'returns false' do
        village = create(:village_with_player, player_num: 5, status: :not_started)
        player = create(:player, user: user, village: village)
        player.exit_from_village

        expect(user.joining_in_village?).to be false
      end
    end
  end

  describe '#joined_village_count' do
    context 'when there is no argument' do
      it 'returns the number of villages that the user joined' do
        village = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
        create(:player, user: user, village: village, role: :villager)

        expect(user.joined_village_count).to eq 1
      end

      context 'when the user is joinning a village in play' do
        it 'does not return the number of villages that is not ended' do
          village_in_play = create(:village_with_player, player_num: 5, status: :in_play)
          create(:player, user: user, village: village_in_play, role: :villager)

          expect(user.joined_village_count).to eq 0
        end
      end

      context 'when there is an ended village that the user exit from' do
        it 'does not return the number of villages that the user exit from' do
          village = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
          player = create(:player, user: user, village: village, role: :villager)
          player.exit_from_village

          expect(user.joined_village_count).to eq 0
        end
      end
    end

    context 'when role of the argument is werewolf' do
      context 'when there is the village that the user joined' do
        context 'when the role of the player is werewolf' do
          it 'returns the number of villages' do
            village = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
            create(:player, user: user, village: village, role: :werewolf)

            expect(user.joined_village_count(role: "werewolf")).to eq 1
          end
        end

        context 'when the role of the player is not werewolf' do
          it 'does not counts the villages' do
            village = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
            create(:player, user: user, village: village, role: :villager)

            expect(user.joined_village_count(role: "werewolf")).to eq 0
          end
        end
      end
    end
  end

  describe '#winned_village_count' do
    context 'when there is no argument' do
      it 'returns the number of villages that the user winned' do
        village = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
        create(:player, user: user, village: village, role: :villager)
        village2 = create(:village_with_player, player_num: 5, status: :ended, winner: :werewolf_win)
        create(:player, user: user, village: village2, role: :werewolf)

        expect(user.winned_village_count).to eq 2
      end

      context 'when there is a village that the user lost' do
        it 'does not counts the village' do
          village = create(:village_with_player, player_num: 5, status: :ended, winner: :werewolf_win)
          create(:player, user: user, village: village, role: :villager)
          village2 = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
          create(:player, user: user, village: village2, role: :werewolf)

          expect(user.winned_village_count).to eq 0
        end
      end
    end

    context 'when role of the argument is werewolf' do
      context 'when there is the village that the user winned' do
        context 'when the role of the player is werewolf' do
          it 'returns the number of villages' do
            village = create(:village_with_player, player_num: 5, status: :ended, winner: :werewolf_win)
            create(:player, user: user, village: village, role: :werewolf)

            expect(user.winned_village_count(role: "werewolf")).to eq 1
          end
        end

        context 'when the role of the player is not werewolf' do
          it 'does not return the number of villages' do
            village = create(:village_with_player, player_num: 5, status: :ended, winner: :human_win)
            create(:player, user: user, village: village, role: :villager)

            expect(user.winned_village_count(role: "werewolf")).to eq 0
          end
        end
      end
    end

    context 'when role of the argument is madman' do
      context 'when there is the village that the user winned' do
        context 'when the role of the player is madman' do
          it 'returns the number of villages' do
            village = create(:village_with_player, player_num: 5, status: :ended, winner: :werewolf_win)
            create(:player, user: user, village: village, role: :madman)

            expect(user.winned_village_count(role: "madman")).to eq 1
          end
        end

        context 'when the role of the player is not madman' do
          it 'does not return the number of villages' do
            village = create(:village_with_player, player_num: 5, status: :ended, winner: :werewolf_win)
            create(:player, user: user, village: village, role: :werewolf)

            expect(user.winned_village_count(role: "madman")).to eq 0
          end
        end
      end
    end
  end
end
