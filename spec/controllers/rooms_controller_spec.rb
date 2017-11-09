require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:user) { create(:confirmed_user) }
  let(:village) { create(:village) }
  let(:valid_attributes) { attributes_for(:room).merge(village_id: village.to_param) }
  let(:valid_session) { {} }

  before do
    sign_in(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      room = Room.create! valid_attributes
      get :index, params: {village: village.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      room = Room.create! valid_attributes
      get :show, params: {id: room.to_param}, session: valid_session
      expect(response).to be_success
    end
  end
end
