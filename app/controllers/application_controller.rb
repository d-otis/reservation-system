class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  private
  
  def authenticate_user
    token, _options = token_and_options(request)
    user_id = AuthenticationTokenService.decode(token)
    @user ||= User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    render status: :unauthorized
  end

  def check_admin_privileges
    render status: :unauthorized if !@user.is_admin?
  end

  def resource_not_found(e)
    render json: { errors: [ e.message ] }, status: :not_found
  end

  def parameter_missing(e)
    render json: { errors: [ e.message ] }, status: :unprocessable_entity
  end
end
