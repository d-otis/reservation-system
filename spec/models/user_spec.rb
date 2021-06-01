require 'rails_helper'

RSpec.describe User, type: :model do
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
    it "is valid w/ valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid when email is already registered" do
      attrs = attributes_for(:user)
      existing_email = User.create(attrs).email
      attrs_with_existing_email = attrs.merge(:email => existing_email)
      expect(User.new(attrs_with_existing_email)).to be_invalid
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
      first_reservation = create(:reservation, :user => user)
      second_reservation = create(:reservation, :user => user)
      expect(user.reservations.count).to eq(2)
      expect(user.reservations).to eq([first_reservation, second_reservation])
    end
  end
end
