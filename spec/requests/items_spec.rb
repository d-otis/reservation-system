require 'rails_helper'

describe "Items API" do
  context 'GET /items' do
    let(:user) { create(:user) }

    it 'returns all items if valid user' do
      token = AuthenticationTokenService.encode(user.id)
      item = create(:item)
      get '/api/v1/items',
        headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:success)
      expect(response_body['data'].size).to eq(1)
    end

    it 'returns 401 Forbidden if user not authenticated' do
      get '/api/v1/items', 
        headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMjM0fQ.EH4nK1B1jv96X5-LRniQWg6OYcQzJG50L7YLY856ks4" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'POST /items' do
    it 'authorized user can create an Item'
    it 'returns forbidden/unauthorized if User is not an admin'
    it 'returns errors if fields are missing'
  end
end