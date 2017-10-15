require 'rails_helper'

RSpec.describe VillagesController, type: :controller do
  let(:user) { create(:confirmed_user) }
  let(:valid_attributes) { attributes_for(:village).merge(user_id: user.to_param) }
  let(:invalid_attributes) { attributes_for(:invalid_village).merge(user_id: user.to_param) }
  before do
    sign_in(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      village = Village.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      village = Village.create! valid_attributes
      get :show, params: {id: village.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      village = Village.create! valid_attributes
      get :edit, params: {id: village.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Village" do
        expect {
          post :create, params: {village: valid_attributes}
        }.to change(Village, :count).by(1)
      end

      it "redirects to the created village" do
        post :create, params: {village: valid_attributes}
        expect(response).to redirect_to(Village.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {village: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {discussion_time: 20}
      }

      it "updates the requested village" do
        village = Village.create! valid_attributes
        put :update, params: {id: village.to_param, village: new_attributes}
        village.reload
        expect(village.discussion_time).to be 20
      end

      it "redirects to the village" do
        village = Village.create! valid_attributes
        put :update, params: {id: village.to_param, village: valid_attributes}
        expect(response).to redirect_to(village)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        village = Village.create! valid_attributes
        put :update, params: {id: village.to_param, village: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested village" do
      village = Village.create! valid_attributes
      expect {
        delete :destroy, params: {id: village.to_param}
      }.to change(Village, :count).by(-1)
    end

    it "redirects to the villages list" do
      village = Village.create! valid_attributes
      delete :destroy, params: {id: village.to_param}
      expect(response).to redirect_to(villages_url)
    end
  end

end
