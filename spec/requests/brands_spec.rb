require 'rails_helper'

require './spec/support/shared_examples/brand_examples'
require './spec/support/shared_examples/user_examples'

describe "Brands API" do
  include_examples "brand examples"
  include_examples "user examples"

  context "GET /brands" do
    it "returns all brands if User is authorized" do
      first_brand = create(:brand)
      second_brand = create(:brand)
      first_item = create(:item, brand: first_brand)

      get '/api/v1/brands',
      headers: {
        "Authorization" => "Bearer #{non_admin_valid_token}"
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data'].length).to eq(2)
      expect(response_body['data'][0]['relationships']['items']['data'].length).to eq(1)
    end

    it "returns successful if User is unauthorized" do
      get '/api/v1/brands',
      headers: {
        "Authorization" => "Bearer #{invalid_token}}"
      }

      expect(response).to have_http_status(:success)
    end

    it "returns successful if no Bearer Token is supplied" do
      get '/api/v1/brands'

      expect(response).to have_http_status(:success)
    end
  end

  context "POST /brands" do
    it "successfully creates a Brand by authorized user and administrator" do
      post '/api/v1/brands',
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      },
      params: {
        brand: { name: 'MOTU' }
      }
      
      expect(response).to have_http_status(:created)
      expect(response_body['data']['attributes']['name']).to eq('MOTU')
    end

    it 'returns error if brand is blank' do
      post '/api/v1/brands',
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "param is missing or the value is empty: brand" ] }
      )
    end

    it 'returns error if brand name is blank' do
      post '/api/v1/brands',
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      },
      params: { brand: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "Name can't be blank" ] }
      )
    end

    it "returns an error if user is not an admin" do
      post '/api/v1/brands',
      headers: {
        "Authorization" => "Bearer #{non_admin_valid_token}"
      },
      params: { brand: attributes_for(:brand) }

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns an error if token isn't supplied" do
      post '/api/v1/brands',
      params: { brand: attributes_for(:brand) }

      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to eq(
        { "errors" => [ "Nil JSON web token" ] }
      )
    end
  end

  context "PUT /brands" do
    it 'returns success when updating a brand with valid admin token'
    it 'returns unauthorized when token is non-admin'
    it 'returns error when name is blank'
    it 'returns error when brand is blank'
    it 'returns error if JWT is not supplied'
  end
end