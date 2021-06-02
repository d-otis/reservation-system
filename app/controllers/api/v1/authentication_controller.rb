class Api::V1::AuthenticationController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def create
    user = User.find_by(email: params.require(:email))

    if user
      token = AuthenticationTokenService.call(user.id)
      puts params.require(:password).inspect

      render json: { token: token }, status: :created
    else
      render json: { error: 'User not found' }, status: :unprocessable_entity
    end
  end

  private

  def parameter_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
end