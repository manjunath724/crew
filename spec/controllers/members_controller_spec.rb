require 'rails_helper'

RSpec.describe MembersController do
  login_user

  let(:valid_session) { {} }

  let(:member) { create(:member) }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}, session: valid_session

      expect(response).to be_successful # be_successful expects a HTTP Status code of 200
    end
  end

  describe "POST #vote" do
    it "returns a success response" do
      post :vote, params: { id: member.id }, session: valid_session

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq "Your vote has been cast properly."
    end

    it "returns a failure response" do
      post :vote, params: { id: member.id }, session: valid_session
      post :vote, params: { id: member.id }, session: valid_session

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq "You have already cast your vote."
    end
  end
end
