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

  context "PUT /reservations" do
    it "successfully updates an owned reservation" do
      reservation = reservation_with_items
      reservation.update(user: non_admin_user)

      put "/api/v1/reservations/#{reservation.id}",
      headers: {
        "Authorization" => "Bearer #{AuthenticationTokenService.encode(non_admin_user.id)}"
      },
      params: {
        reservation: {
          start_time: reservation.start_time,
          end_time: reservation.end_time,
          note: "this is a new note!",
          item_ids: reservation.item_ids.slice(0,2)
        }
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data']['attributes']['note']).to eq("this is a new note!")
      expect(response_body['data']['relationships']['items']['data'].length).to eq(2)
    end

    it "returns error when user tries to update reservation that is not theirs" do
      first_user = create(:user, :is_admin => false)
      second_user = create(:user, :is_admin => false)
      reservation = create(:reservation, user: first_user)

      put "/api/v1/reservations/#{reservation.id}",
      headers: {
        "Authorization" => "Bearer #{AuthenticationTokenService.encode(second_user.id)}"
      },
      params: {
        reservation: {
          start_time: reservation.start_time,
          end_time: reservation.end_time,
          note: "I don't own this reservation!",
          item_ids: []
        }
      }

      expect(response).to have_http_status(:forbidden)
      expect(response_body).to eq({
        "errors" => ["Insufficient privileges."]
      })
    end

    it "successfully updates reservation when user is admin but not owner" do
      reservation = reservation_with_items
      reservation.update(user: user)

      put "/api/v1/reservations/#{reservation.id}",
      headers: admin_header,
      params: {
        reservation: {
          start_time: reservation.start_time,
          end_time: reservation.end_time,
          note: "admin editing someone else's reservation",
          item_ids: reservation.item_ids.slice(0,2)
        }
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data']['relationships']['items']['data'].length).to eq(2)
      expect(response_body['data']['attributes']['note']).to eq("admin editing someone else's reservation")
    end

    it "renders Unprocessable Entity status codes and errors when required params are missing" do
      reservation = create(:reservation, :user => user)

      put "/api/v1/reservations/#{reservation.id}",
      headers: random_user_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        "errors" => [ "param is missing or the value is empty: reservation" ]
      })
    end

    it "returns error of record not found" do
      put "/api/v1/reservations/#{999999}",
      headers: random_user_header

      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq({
        "errors" => [ "Couldn't find Reservation with 'id'=999999" ]
      })
    end

    it "returns Unauthorized if JWT is invalid" do
      put "/api/v1/reservations/#{reservation_with_items.id}",
      headers: invalid_header,
      params: {
        reservation: {
          start_time: reservation_with_items.start_time,
          end_time: reservation_with_items.end_time,
          note: "unauthorized JWT",
          item_ids: reservation_with_items.item_ids.slice(0,2)
        }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "DELETE /reservations" do
    it "successfully deletes a reservation that user owns" do
      reservation = create(:reservation, :user => user)

      delete "/api/v1/reservations/#{reservation.id}",
      headers: random_user_header

      expect(response).to have_http_status(:accepted)
      expect(response_body['data']['id'].to_i).to eq(reservation.id)
    end

    it "returns Unauthorized if user isn't admin and doesn't own reservation" do
      reservation = create(:reservation, :user => user)

      delete "/api/v1/reservations/#{reservation.id}",
      headers: non_admin_header

      expect(response).to have_http_status(:forbidden)
    end

    it "successfully deletes a reservation if user is admin, but doesn't own reservation" do
      reservation = create(:reservation)

      delete "/api/v1/reservations/#{reservation.id}",
      headers: admin_header

      expect(response).to have_http_status(:accepted)
      expect(response_body['data']['id'].to_i).to eq(reservation.id)
    end

    it "returns Unauthorized if JWT is invalid" do
      reservation = create(:reservation)

      delete "/api/v1/reservations/#{reservation.id}",
      headers: invalid_header

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns error if record not found" do
      delete "/api/v1/reservations/#{9234918}",
      headers: non_admin_header

      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq({
        "errors" => ["Couldn't find Reservation with 'id'=9234918"]
      })
    end

    it "returns error if JWT is nil" do
      reservation = create(:reservation)

      delete "/api/v1/reservations/#{reservation.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end