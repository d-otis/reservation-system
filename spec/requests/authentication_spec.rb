require 'rails_helper'

describe "Authentication", type: :request do
  describe 'POST /authenticate' do
    let(:user) { create(:user, email:'cooldude99@gmail.com') }
    it 'authenticates the client' do
      post '/api/v1/authenticate', params: { email: user.email, password: "asdfasdf" }

      expect(response).to have_http_status(:created)
      expect(response_body).to eq({
        "token"=>"123"
      })
    end

    it "returns error when email is missing" do
      post '/api/v1/authenticate', params: { password: "asdf" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: email'
      })
    end

    it "returns error when password is missing" do
      post '/api/v1/authenticate', params: { email: 'cooldude99@gmail.com' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: password'
      })
    end
  end
end