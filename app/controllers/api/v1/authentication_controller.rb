class Api::V1::AuthenticationController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def create
    puts params.require(:email).inspect
    puts params.require(:password).inspect

    render json: { token: '123' }, status: :created
  end

  private

  def parameter_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
end