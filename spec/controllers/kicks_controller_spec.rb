require 'rails_helper'

RSpec.describe Villages::KicksController, type: :controller do
  let(:user) { create(:confirmed_user) }
  let(:other_user) { create(:confirmed_user) }

  describe "PUT #update" do
    before do
      sign_in(user)
    end

    it "kicks the player" do
      village = create(:village_with_player, player_num: 5, user: user)
      kicked_player = village.players.first
      put :update, params: {village_id: village.id, player: {id: kicked_player.id}}
      village.reload
      expect(village.players.count).to be 4
    end
  end
end
