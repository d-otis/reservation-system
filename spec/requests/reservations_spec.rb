require 'rails_helper'

describe 'Reservations API', type: :request do

  context 'GET /reservations' do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:second_user_token) { AuthenticationTokenService.encode(second_user.id) }

    it 'returns all owned reservations with valid Authorization Bearer Token' do
      authorized_reservation = create(:reservation, :user => first_user)
      unauthorized_reservation = create(:reservation)
      authorized_reservation.items << create(:item)
      token = AuthenticationTokenService.encode(first_user.id)
      get '/api/v1/reservations', headers: { "Authorization" => "Bearer #{token}"}

      expect(response).to have_http_status(:success)
      expect(response_body['data'].size).to eq(1)
      expect(response_body['data'].first['type']).to eq('reservation')
      expect(response_body['data'].first['relationships']['items']['data'].count).to eq(1)
    end

    it 'returns 401 Forbidden if not authenticated' do
      get '/api/v1/reservations', headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMjM0fQ.EH4nK1B1jv96X5-LRniQWg6OYcQzJG50L7YLY856ks4" }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns only owned reservations' do
      create(:reservation, :user => first_user)

      get '/api/v1/reservations',
      headers: {
        "Authorization" => "Bearer #{second_user_token}"
      }

      expect(response_body['data'].size).to eq(0)
      expect(response_body).to eq( { "data" => [] } )
    end
  end
end