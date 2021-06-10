require 'rails_helper'
require './spec/support/shared_examples/user_examples'
require './spec/support/shared_examples/items_examples'
require './spec/support/shared_examples/brand_examples'

describe "Items API" do
  include_examples "user examples"
  include_examples "items examples"
  include_examples "brand examples"

  context 'GET /items' do

    it 'returns all items if valid user' do
      item = create(:item)

      get '/api/v1/items',
        headers: non_admin_header

      expect(response).to have_http_status(:success)
      expect(response_body['data'].size).to eq(1)
    end
  end

  context 'POST /items' do

    it 'authorized user can create an Item' do
      post '/api/v1/items',
      headers: admin_header,
      params: { "item": attributes_for(:item, :brand_id => brand.id) }

      expect(response).to have_http_status(:created)
    end

    it 'returns 401 Forbidden if User not authenticated' do
      post '/api/v1/items',
      headers: invalid_header,
      params: { "item": attributes_for(:item, :brand_id => brand.id) }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 Forbidden if User is not an admin' do
      post '/api/v1/items',
      headers: non_admin_header,
      params: { "item": attributes_for(:item, :brand_id => brand.id) }
  
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 422 Status JSON errors if fields are missing' do
      post '/api/v1/items',
      headers: admin_header,
      params: { "item": attributes_for(:item) }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        { "errors" => [ "Brand must exist" ] }
      )
    end
  end

  context 'PUT /items/:id' do

    it 'successfully updates an item by an authorized and authenticated user' do
      put "/api/v1/items/#{item.id}",
      headers: admin_header,
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
      headers: admin_header,
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
      headers: admin_header,
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

    it "returns 401 forbidden if non_admin user tries to update an Item" do
      put "/api/v1/items/#{item.id}",
      headers: non_admin_header

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'DELETE /items' do

    it 'successfully deletes Item if user is admin' do
      delete "/api/v1/items/#{item.id}",
      headers: admin_header

      expect(response).to have_http_status(:accepted)
      expect(response_body['data']['id'].to_i).to eq(item.id)
    end

    it 'renders 404 if resource not found' do
      delete "/api/v1/items/99999",
      headers: admin_header

      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq({"errors"=>["Couldn't find Item with 'id'=99999"]})
    end

    it 'renders unauthorized error message if user is not an admin' do
      delete "/api/v1/items/#{item.id}",
      headers: invalid_header

      expect(response).to have_http_status(:unauthorized)
      expect(item.destroyed?).to eq(false)
    end
  end
end