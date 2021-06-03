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
  end

  context 'POST /items' do
    let(:admin_valid_token) { AuthenticationTokenService.encode(admin_user.id) }
    let(:non_admin_valid_token) { AuthenticationTokenService.encode(non_admin_user.id) }
    let(:invalid_token) { AuthenticationTokenService.encode(9999) }
    let(:admin_user) { create(:user, :is_admin => true) }
    let(:non_admin_user) { create(:user, :is_admin => false) }
    let(:brand) { create(:brand) }

    it 'authorized user can create an Item' do
      post '/api/v1/items',
      headers: { "Authorization" => "Bearer #{admin_valid_token}" },
      params: { "item": attributes_for(:item, :brand_id => brand.id) }

      expect(response).to have_http_status(:created)
    end

    it 'returns 401 Forbidden if User not authenticated' do
      post '/api/v1/items',
      headers: { "Authorization" => "Bearer #{invalid_token}" },
      params: { "item": attributes_for(:item, :brand_id => brand.id) }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 Forbidden if User is not an admin' do
      post '/api/v1/items',
      headers: { "Authorization" => "Bearer #{non_admin_valid_token}" },
      params: { "item": attributes_for(:item, :brand_id => brand.id) }
  
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 422 Status JSON errors if fields are missing' do
      post '/api/v1/items',
      headers: { "Authorization": "Bearer #{admin_valid_token}" },
      params: { "item": attributes_for(:item) }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "Brand must exist" ] }
      )
    end
  end

  context 'PUT /items/:id' do
    let(:admin_valid_token) { AuthenticationTokenService.encode(admin_user.id) }
    let(:non_admin_valid_token) { AuthenticationTokenService.encode(non_admin_user.id) }
    let(:invalid_token) { AuthenticationTokenService.encode(9999) }
    let(:admin_user) { create(:user, :is_admin => true) }
    let(:non_admin_user) { create(:user, :is_admin => false) }
    let(:brand) { create(:brand) }
    let(:item) { create(:item) }

    it 'successfully updates an item by an authorized and authenticated user' do
      put "/api/v1/items/#{item.id}",
      headers: { "Authorization" => "Bearer #{admin_valid_token}" },
      params: { 
        item: { 
          name: "New Name", 
          description: "New Description", 
          serial_number: "New Serial" 
        } 
      }

      expect(response).to have_http_status(:success)
    end

    it 'renders 404 if Item not found in database' do
      put '/api/v1/items/9999',
      headers: { "Authorization" => "Bearer #{admin_valid_token}" },
      params: {
        item: {
          name: "New Name",
          description: "New Description",
          serial_number: "New Serial"
        }
      }
      
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq( { "errors"=>[ "Couldn't find Item with 'id'=9999" ] } )
    end

    it 'renders 422 if any required attributes/params are missing' do
      put "/api/v1/items/#{item.id}",
      headers: { "Authorization" => "Bearer #{admin_valid_token}" },
      params: {
        item: {
          name: "",
          description: "",
          serial_number: ""
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq( { "errors" => [ "Name can't be blank", "Description can't be blank" ] } )
    end
  end
end