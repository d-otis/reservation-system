class AuthenticationTokenService
  HMAC_SECRET = 'my$ecretK3y'
  ALGORITHM_TYPE = 'HS256'

  def self.encode(user_id)
    payload = { user_id: user_id } # payload

    JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
  end
end