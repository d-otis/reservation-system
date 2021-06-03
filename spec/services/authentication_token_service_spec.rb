require 'rails_helper'

RSpec.describe AuthenticationTokenService do
  describe '.encode' do
    
    let(:user) { create(:user) }
    let(:token) { token = described_class.encode(user.id) }

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

  describe '.decode' do
    it 'decodes JWT sent from client & returns user_id' do
      token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo5OTl9.PTh8OJetG_17eAd3aKCcac7s5uL_mKomIhqnPPDPs0U"
      user_id = described_class.decode(token)

      expect(user_id).to eq(999)
    end
  end
end