class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, :except => [:create]

  def index
    users = @user.is_admin? ? User.all : @user
    render json: UserSerializer.new(users).serializable_hash.to_json
  end

end