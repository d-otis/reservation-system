class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

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
end
