require 'rails_helper'

RSpec.describe AuthenticationTokenService do
  describe '.call' do
    
    let(:user) { create(:user) }
    let(:token) { token = described_class.call(user.id) }

    it 'returns an authentication token' do
      decoded_token = JWT.decode(
        token, 
        described_class::HMAC_SECRET, 
        true, 
        { algorithm: described_class::ALGORITHM_TYPE })

      expect(decoded_token).to eq([
          {"user_id"=> user.id }, # payload
          {"alg"=>"HS256"} # header
      ])
    end
  end
end