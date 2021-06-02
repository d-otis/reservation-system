class Api::V1::AuthenticationController < ApplicationController
  def create
    puts params.inspect

    render json: { token: '123' }, status: :created
  end
end