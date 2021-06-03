class Api::V1::AuthenticationController < ApplicationController
  class AuthenticationError < StandardError; end
  rescue_from AuthenticationError, with: :handle_unauthenticated

  def create
    raise AuthenticationError unless user.authenticate(params.require(:password))
    token = AuthenticationTokenService.encode(user.id)
    render json: { token: token }, status: :created
  end

  private

  def user
    @user ||= User.find_by(email: params.require(:email))
  end

  def handle_unauthenticated
    head :unauthorized
  end
end