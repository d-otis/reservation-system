require 'rails_helper'
require 'reservation_examples'
require 'user_examples'
require 'item_examples'

RSpec.describe Reservation, type: :model do
  include_examples "user examples"
  include_examples "reservation examples"
  include_examples "item examples"

  let(:reservation_attrs_with_user) { valid_reservation_attrs.merge(user: test_user) }
  let(:brand_1) { Brand.create(name: "MOTU") }
  let(:brand_2) { Brand.create(name: "Shure") }

  context "Attributes" do
    it "has a start_time attribute" do
      expect(Reservation.new).to respond_to(:start_time)
    end

    it "has a end_time attribute" do
      expect(Reservation.new).to respond_to(:end_time)
    end

    it "has a note attribute" do
      expect(Reservation.new).to respond_to(:note)
    end

    it "has a user_id attribute" do
      expect(Reservation.new).to respond_to(:user_id)
    end

    it "has a user macro attribute" do
      expect(Reservation.new).to respond_to(:user)
    end

    it "has an items macro attribute" do
      expect(Reservation.new).to respond_to(:items)
    end
  end

  context "Validations" do
    it "is valid with valid attributes" do
      reservation = Reservation.new(reservation_attrs_with_user)
      expect(reservation).to be_valid
    end

    it "is invalid without a User" do
      expect(Reservation.new(valid_reservation_attrs)).to be_invalid
    end

    it "is valid with missing note" do
      expect(Reservation.new(reservation_attrs_with_user.except(:note))).to be_valid
    end

    it "is invalid with missing start_time" do
      expect(Reservation.new(reservation_attrs_with_user.except(:start_time))).to be_invalid
    end

    it "is invalid with missing end_time" do
      expect(Reservation.new(reservation_attrs_with_user.except(:end_time))).to be_invalid
    end

    it "is invalid with end_time previous to start_time" do
      start_time = DateTime.now
      end_time = start_time - 2
      reservation = Reservation.new(user: test_user, start_time: start_time, end_time: end_time)
      expect(reservation).to be_invalid
    end
  end

  context "Associations" do
    it "is owned by a User" do
      reservation = Reservation.create(reservation_attrs_with_user)
      expect(test_user.reservations.include?(reservation)).to be(true)
    end
    
    it "has many Items" do
      item = Item.create(valid_item_attrs.merge(:brand => brand_1))
      item_2 = Item.create(more_valid_item_attrs.merge(:brand => brand_2))
      reservation = Reservation.create(reservation_attrs_with_user)
      reservation.items << item
      reservation.items << item_2
      expect(reservation.items).to eq([item, item_2])
      expect(reservation.items.count).to eq(2)
    end

    it "cannot have the same item twice" do
      item = Item.create(valid_item_attrs.merge(:brand => brand_1))
      reservation = Reservation.create(reservation_attrs_with_user)
      reservation.items << item
      expect{ reservation.items << item }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
