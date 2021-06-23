class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, :except => [:create]

  def index
    users = @user.is_admin? ? User.all : @user
    render json: UserSerializer.new(users).serializable_hash.to_json
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: UserSerializer.new(user).serializable_hash.to_json, status: :created
    else
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end