require 'rails_helper'

describe "Authentication", type: :request do
  describe 'POST /authenticate' do
    it 'authenticates the client' do
      post '/api/v1/authenticate', params: { email: 'cooldude99@gmail.com', password: "asdfasdf" }

      expect(response).to have_http_status(:created)
      expect(response_body).to eq({"token"=>"123"})
    end
  end
end