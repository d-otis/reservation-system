RSpec.shared_examples "user examples" do
  let(:valid_user_attrs) do 
    {
      :first_name => "Patsy",
      :last_name => "Cline",
      :email => "bluemoonkentucky@gmail.com",
      :is_admin => true
      # :password => "crazy!1234%^&",
      # :password_confirmation => "crazy!1234%^&"
    }
  end

  let(:test_user) { User.create(valid_user_attrs) }
end