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

      expect(response).to have_http_status(:forbidden)
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

  context "PUT /brands/:id" do
    it 'returns success when updating a brand with valid admin token' do
      put "/api/v1/brands/#{brand.id}",
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      },
      params: {
        brand: { name: "Sony" }
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data']['id'].to_i).to eq(brand.id)
    end

    it 'returns Record Not Found error if not found' do
      put "/api/v1/brands/9999",
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      },
      params: {
        brand: { name: "Panasonic" }
      }

      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(
        { "errors" => [ "Couldn't find Brand with 'id'=9999" ] }
      )
    end

    it 'returns unauthorized when token is non-admin' do
      put "/api/v1/brands/#{brand.id}",
      headers: {
        "Authorization" => "Bearer #{non_admin_valid_token}"
      },
      params: { brand: { name: "Behringer" } }

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns error when name is blank' do
      put "/api/v1/brands/#{brand.id}",
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      },
      params: {
        brand: { name: "" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "Name can't be blank" ] }
      )
    end

    it 'returns error when brand is blank' do
      put "/api/v1/brands/#{brand.id}",
      headers: {
        "Authorization" => "Bearer #{admin_valid_token}"
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "param is missing or the value is empty: brand" ] }
      )
    end

    it 'returns error if JWT is not supplied' do
      put "/api/v1/brands/#{brand.id}",
      params: {
        brand: { name: "Panasonic" }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "DELETE /brands" do
    it "admin user can successfully deletes brand and its items" do
      delete "/api/v1/brands/#{brand.id}",
      headers: admin_header

      expect(response).to have_http_status(:accepted)
      expect(response_body['data']['id'].to_i).to eq(brand.id)
    end

    it 'returns forbidden error when not admin' do
      delete "/api/v1/brands/#{brand.id}",
      headers: non_admin_header

      expect(response).to have_http_status(:forbidden)
    end

    it "returns unauthorized error when JWT isn't supplied" do
      delete "/api/v1/brands/#{brand.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 404 if brand not found" do
      delete "/api/v1/brands/9999",
      headers: admin_header
  
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq({
        "errors" => [ "Couldn't find Brand with 'id'=9999" ]
      })
    end
  end
end