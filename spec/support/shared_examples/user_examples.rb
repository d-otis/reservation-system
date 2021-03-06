RSpec.shared_examples "user examples" do
  let(:admin_user) { create(:user, :is_admin => true) }
  let(:non_admin_user) { create(:user, :is_admin => false) }
  let(:admin_valid_token) { AuthenticationTokenService.encode(admin_user.id) }
  let(:non_admin_valid_token) { AuthenticationTokenService.encode(non_admin_user.id) }
  let(:invalid_token) { AuthenticationTokenService.encode(9999) }
  let(:user) { create(:user) }
  # random as in: could be admin or non-admin
  let(:random_user_token) { AuthenticationTokenService.encode(user.id) }
end