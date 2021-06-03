require 'rails_helper'

describe "Items API" do
  context 'GET /items' do
    let(:user) { create(:user) }
    let(:token) { AuthenticationTokenService.encode(user.id) }

    it 'returns all items if valid user' do
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
    let(:valid_token) { AuthenticationTokenService.encode(user.id) }
    let(:invalid_token) { AuthenticationTokenService.encode(9999) }
    let(:user) { create(:user) }
    let(:brand) { create(:brand) }

    it 'authorized user can create an Item' do
      post '/api/v1/items',
      headers: { "Authorization" => "Bearer #{valid_token}" },
      params: { "item": attributes_for(:item, :brand_id => brand.id) }

      expect(response).to have_http_status(:created)
    end

    it 'returns 401 forbidden/unauthorized if User is not an admin' do
      post '/api/v1/items',
      headers: { "Authorization" => "Bearer #{invalid_token}" },
      params: { "item": attributes_for(:item, :brand_id => brand.id) }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 422 Status JSON errors if fields are missing' do
      post '/api/v1/items',
      headers: { "Authorization": "Bearer #{valid_token}" },
      params: { "item": attributes_for(:item) }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "Brand must exist" ] }
      )
    end
  end
end