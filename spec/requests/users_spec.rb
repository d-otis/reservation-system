require 'rails_helper'

require './spec/support/shared_examples/user_examples'

describe "Users API" do
  include_examples "user examples"

  context "GET /users" do

    it "displays all users for admin users" do
      second_user = create(:user, :is_admin => false)

      get "/api/v1/users",
      headers: admin_header

      expect(response).to have_http_status(:success)
      expect(response_body['data']).to be_an_instance_of(Array)
      expect(response_body['data'].count).to eq(2)
    end

    it "only displays current user if user is not admin" do
      second_user = create(:user)
      
      get "/api/v1/users",
      headers: non_admin_header

      expect(response).to have_http_status(:success)
      expect(response_body).to have_key('data')
      expect(response_body).to be_an_instance_of(Hash)
      expect(response_body['data']).to include('id' => non_admin_user.id.to_s)
    end

    it "returns Unauthorized Status Code and error when JWT isn't supplied" do
      get '/api/v1/users'

      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to eq({
        "errors" => [ "Nil JSON web token" ]
      })
    end

    it "returns Unauthorized Status Code with invalid token" do
      get '/api/v1/users',
      headers: invalid_header

      expect(response).to have_http_status(:unauthorized)
    end

  end

  context "POST /users" do
    it "successfully creates a new user" do
      user_attrs = attributes_for(:user).except(:is_admin)

      post '/api/v1/users',
      params: {
        user: user_attrs
      }

      expect(response).to have_http_status(:created)
      expect(response_body).to be_an_instance_of(Hash)
      expect(response_body).to have_key('data')
      expect(response_body['data']['attributes']['email']).to eq(user_attrs[:email])
    end

    it "returns errors if required user params are missing" do
      post '/api/v1/users'

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        "errors" => [ "param is missing or the value is empty: user" ]
      })
    end

    it "returns errors if user param is missing" do
      post "/api/v1/users"

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        "errors" => [ "param is missing or the value is empty: user" ]
      })
    end
  end

  context "PUT /users/:id" do
    it "allows non admin user to update themselves" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: non_admin_header,
      params: {
        user: attributes_for(:user, :is_admin => false)
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data']['id'].to_i).to eq(non_admin_user.id)
    end

    it "allows admin user to update themselves" do
      put "/api/v1/users/#{admin_user.id}",
      headers: admin_header,
      params: {
        user: attributes_for(:user, is_admin: true)
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data']['id'].to_i).to eq(admin_user.id)
    end

    it "allows admin users to make another user an admin" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: admin_header,
      params: {
        user: attributes_for(:user, is_admin: true)
      }

      expect(response).to have_http_status(:success)
      expect(response_body['data']['attributes']['is_admin']).to eq(true)
    end

    it "doesn't allow a user to make themselves an admin" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: non_admin_header,
      params: {
        user: attributes_for(:user, is_admin: true)
      }

      expect(response).to have_http_status(:forbidden)
      expect(response_body).to eq({
        "errors" => [ "Must be admin to execute action." ]
      })
    end

    it "doesn't allow non-admin user to update another user" do
      put "/api/v1/users/#{user.id}",
      headers: non_admin_header,
      params: {
        user: attributes_for(:user)
      }

      expect(response).to have_http_status(:forbidden)
      expect(response_body).to eq({
        "errors" => [ "Insufficient privileges." ]
      })
    end

    it "allows admin user to update another user" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: admin_header,
      params: {
        user: attributes_for(:user)
      }

      expect(response).to have_http_status(:success)
    end

    it "returns errors if user param is missing" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: non_admin_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        "errors" => [ "param is missing or the value is empty: user" ]
      })
    end

    it "returns errors if required user params are missing" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: non_admin_header,
      params: {
        user: attributes_for(:user, :email => "", :is_admin => false)
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        "errors" => [ "Email can't be blank" ]
      })
    end

    it "returns error if JWT is invalid" do
      put "/api/v1/users/#{non_admin_user.id}",
      headers: invalid_header,
      params: {
        user: attributes_for(:user)
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns error if JWT is no supplied" do
      put "/api/v1/users/#{non_admin_user.id}",
      params: {
        user: attributes_for(:user)
      }

      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to eq({
        "errors" => [ "Nil JSON web token" ]
      })
    end
  end

  context "DELETE /users/:id" do
    it "successfully allows users to delete themselves"
    it "successfully allows admin user to delete another user"
    it "doesn't allow user to delete another user"
    it "returns errors if user isn't found"
    it "returns errors if JWT is invalid"
    it "returns errors if no JWT is provided"
  end
end