require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { create(:confirmed_user) }

  before do
    login_as user, scope: :user
  end

  describe "GET /api/v1/rooms" do
    it "works! (now write some real specs)" do
      get api_v1_rooms_path
      expect(response).to have_http_status(200)
    end
  end
end
