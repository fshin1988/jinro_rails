require 'rails_helper'

RSpec.describe Api::V1::RecordsController, type: :controller do

  let(:village) { create(:village) }
  let(:player) { create(:player) }
  let(:valid_attributes) { attributes_for(:record).merge(village_id: village.to_param).merge(player_id: player.to_param) }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      record = Record.create! valid_attributes
      get :index, params: {village: village.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {vote_target_id: 1}
      }
      it "updates vote_target_id" do
        record = Record.create! valid_attributes
        put :update, params: {id: record.to_param, record: new_attributes}, session: valid_session
        record.reload
        expect(record.vote_target_id).to eq 1
      end
    end
  end
end
