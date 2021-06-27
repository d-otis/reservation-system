class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, :except => [:create]
  before_action :set_user_resource, :except => [:index, :create]
  before_action :check_user_ownership, :only => [:update, :destroy]
  before_action :escalating_privilege_check, :only => [:update]

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

  def update
    if @user_resource.update(user_params)
      render json: UserSerializer.new(@user_resource).serializable_hash.to_json, status: :ok
    else
      render json: { errors: @user_resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user_resource.destroy
    render json: UserSerializer.new(@user_resource).serializable_hash.to_json, status: :accepted
  end

  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :is_admin)
  end

  def set_user_resource
    @user_resource ||= User.find(params[:id])
  end

  def escalating_privilege_check
    if !@user.is_admin? && !@user_resource.is_admin? && user_params[:is_admin] == "true"
      render json: { errors: ["Must be admin to execute action."] }, status: :forbidden
      return
    end
  end

  def check_user_ownership
    render json: { errors: [ "Insufficient privileges." ] }, status: :forbidden unless @user.is_admin? || @user == @user_resource 
  end
end