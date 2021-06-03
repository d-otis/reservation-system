RSpec.shared_examples "items examples" do
  let(:admin_valid_token) { AuthenticationTokenService.encode(admin_user.id) }
  let(:non_admin_valid_token) { AuthenticationTokenService.encode(non_admin_user.id) }
  let(:invalid_token) { AuthenticationTokenService.encode(9999) }
  let(:admin_user) { create(:user, :is_admin => true) }
  let(:non_admin_user) { create(:user, :is_admin => false) }
  let(:brand) { create(:brand) }
  let(:item) { create(:item) }
end