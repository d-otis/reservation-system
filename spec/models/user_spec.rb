require 'rails_helper'
require 'user_examples'
require 'reservation_examples'

RSpec.describe User, type: :model do
  include_examples "user examples"
  include_examples "reservation examples"

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
    let(:missing_first_name) { valid_user_attrs.except(:first_name) }
    let(:missing_last_name) { valid_user_attrs.except(:last_name) }
    let(:missing_email) { valid_user_attrs.except(:email) }
    let(:missing_is_admin) { valid_user_attrs.except(:is_admin) }

    it "is valid w/ valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid when email is already registered" do
      attrs = attributes_for(:user)
      existing_email = User.create(attrs).email
      expect(User.new(attrs.merge(email: existing_email))).to be_invalid
    end

    it "is invalid w/o first_name" do
      user = build(:user, :first_name => nil)
      expect(user).to be_invalid
    end

    it "is invalid w/o last_name" do
      user = build(:user, :last_name => nil)
      expect(user).to be_invalid
    end

    it "is invalid w/o email" do
      user = build(:user, :email => nil)
      expect(user).to be_invalid
    end

    it "is invalid w/o is_admin" do
      user = build(:user, :is_admin => nil)
      expect(user).to be_invalid
    end
  end

  context "Associations" do
    it "can have many reservations" do
      user = create(:user)
      reservation_1 = user.reservations.create(valid_reservation_attrs)
      reservation_2 = user.reservations.create(valid_reservation_attrs)
      expect(user.reservations.count).to eq(2)
      expect(user.reservations).to eq([reservation_1, reservation_2])
    end
  end
end
