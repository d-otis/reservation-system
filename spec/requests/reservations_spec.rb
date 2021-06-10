require 'rails_helper'
require './spec/support/shared_examples/user_examples'

describe 'Reservations API', type: :request do
  include_examples "user examples"

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
      get '/api/v1/reservations', 
      headers: invalid_header

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns only owned reservations' do
      get '/api/v1/reservations',
      headers: non_admin_header

      expect(response_body['data'].size).to eq(0)
      expect(response_body).to eq( { "data" => [] } )
    end
  end

  context 'POST /reservations' do
    let(:first_item) { create(:item) }
    let(:second_item) { create(:item) }
    let(:res_attrs) { attributes_for(:reservation) }

    it 'successfully allows authenticated user to create reservation' do
      post '/api/v1/reservations',
      headers: random_user_header,
      params: { 
        reservation: res_attrs.merge(:item_ids => [ first_item.id, second_item.id ]) 
      }

      expect(response).to have_http_status(:created)
      expect(response_body['data']['relationships']['items']['data'].size).to eq(2)
    end

    it 'returns error status and message when unauthenticated attempts to create reservation' do
      post '/api/v1/reservations',
      headers: invalid_header,
      params: {
        reservation: attributes_for(:reservation).merge(:item_ids => [ first_item.id, second_item.id ], :user_id => user.id) 
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error when missing required params' do
      post '/api/v1/reservations',
      headers: random_user_header,
      params: {
        reservation: attributes_for(:reservation).except(:start_time).merge(:item_ids => [ first_item.id, second_item.id ]) 
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({"errors"=>["Start time can't be blank"]})
    end
  end
end