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
    it "successfully creates a new user"
    it "returns errors if required user params are missing"
    it "returns errors if user param is missing"
  end

  context "PUT /users/:id" do
    it "allows user to update themselves"
    it "allows admin users to make another user an admin"
    it "doesn't allow a user to make themselves an admin"
    it "returns errors if user param is missing"
    it "returns errors if required user params are missing"
    it "returns error if JWT is invalid"
    it "returns error if JWT is no supplied"
  end
end