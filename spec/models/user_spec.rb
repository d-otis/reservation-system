require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "Attributes" do
    it "has first_name attr" do
      expect(User.new).to respond_to(:first_name)
    end

    it "has last_name attr" do
      expect(User.new).to respond_to(:last_name)
    end

    it "has is_admin attr" do
      expect(User.new).to respond_to(:is_admin)
    end

    it "has #full_name instance method" do
      expect(User.new).to respond_to(:full_name)
      expect(User.new(:first_name => "Patsy", :last_name => "Cline").full_name).to eq("Patsy Cline")
    end
  end

  context "Validations" do
    let(:valid_attrs) do 
      {
        :first_name => "Patsy",
        :last_name => "Cline",
        :email => "bluemoonkentucky@gmail.com",
        :is_admin => true
        # :password => "crazy!1234%^&",
        # :password_confirmation => "crazy!1234%^&"
      }
    end

    let(:missing_first_name) { valid_attrs.except(:first_name) }
    let(:missing_last_name) { valid_attrs.except(:last_name) }
    let(:missing_email) { valid_attrs.except(:email) }
    let(:missing_is_admin) { valid_attrs.except(:is_admin) }

    it "is valid w/ valid attributes" do
      expect(User.new(valid_attrs)).to be_valid
    end

    it "is invalid when email is already registered" do
      User.create(valid_attrs)
      expect(User.new(valid_attrs)).to be_invalid
    end

    it "is invalid w/o first_name" do
      expect(User.new(missing_first_name)).to be_invalid
    end

    it "is invalid w/o last_name" do
      expect(User.new(missing_last_name)).to be_invalid
    end

    it "is invalid w/o email" do
      expect(User.new(missing_email)).to be_invalid
    end

    it "is invalid w/o is_admin" do
      expect(User.new(missing_email)).to be_invalid
    end
  end
end
