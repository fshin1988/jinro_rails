require 'rails_helper'
RSpec.describe 'Records API', type: :request do
  describe 'vote API' do
    context 'as an authenticated user' do
      before do
        @user = create(:confirmed_user)
      end

      it 'update vote_target_id of record of the user' do
        village = create(:village_with_player, player_num: 5)
        village.start!
        village.players.first.update(user: @user)
        other_player = village.players.last
        sign_in @user

        put "/api/v1/records/#{village.record_from_user(@user).id}/vote",
            params: {record: {vote_target_id: other_player.id}}
        expect(response).to have_http_status(200)
        expect(village.record_from_user(@user).vote_target_id).to eq other_player.id
      end
    end

    context 'as an user who is not a player of the village' do
      before do
        @user = create(:confirmed_user)
      end

      it 'returns status code 400' do
        village = create(:village_with_player, player_num: 5)
        village.start!
        other_player = village.players.last
        sign_in @user

        put "/api/v1/records/#{village.records.first.id}/vote",
            params: {record: {vote_target_id: other_player.id}}
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'attack API' do
    context 'as an authenticated user' do
      before do
        @user = create(:confirmed_user)
      end

      it 'update attack_target_id of record of the user' do
        village = create(:village_with_player, player_num: 5)
        village.start!
        village.players.werewolf.first.update(user: @user)
        other_player = village.players.last
        sign_in @user

        put "/api/v1/records/#{village.record_from_user(@user).id}/attack",
            params: {record: {attack_target_id: other_player.id}}
        expect(response).to have_http_status(200)
        expect(village.record_from_user(@user).attack_target_id).to eq other_player.id
      end
    end
  end

  describe 'divine API' do
    context 'as an authenticated user' do
      before do
        @user = create(:confirmed_user)
      end

      it 'update divine_target_id of record of the user' do
        village = create(:village_with_player, player_num: 5)
        village.start!
        village.players.fortune_teller.first.update(user: @user)
        other_player = village.players.last
        sign_in @user

        put "/api/v1/records/#{village.record_from_user(@user).id}/divine",
            params: {record: {divine_target_id: other_player.id}}
        expect(response).to have_http_status(200)
        expect(village.record_from_user(@user).divine_target_id).to eq other_player.id
      end
    end
  end

  describe 'guard API' do
    context 'as an authenticated user' do
      before do
        @user = create(:confirmed_user)
      end

      it 'update guard_target_id of record of the user' do
        village = create(:village_with_player, player_num: 10)
        village.start!
        village.players.bodyguard.first.update(user: @user)
        other_player = village.players.last
        sign_in @user

        put "/api/v1/records/#{village.record_from_user(@user).id}/guard",
            params: {record: {guard_target_id: other_player.id}}
        expect(response).to have_http_status(200)
        expect(village.record_from_user(@user).guard_target_id).to eq other_player.id
      end
    end
  end
end
