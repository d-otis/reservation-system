require 'rails_helper'

RSpec.describe Reservation, type: :model do
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
      reservation = create(:reservation)
      expect(reservation).to be_valid
    end

    it "is invalid without a User" do
      attrs_missing_user = attributes_for(:reservation).except(:user)
      expect(Reservation.new(attrs_missing_user)).to be_invalid
    end

    it "is valid with missing note" do
      reservation_missing_note = build(:reservation, :note => nil)
      expect(reservation_missing_note).to be_valid
    end

    it "is invalid with missing start_time" do
      attrs_missing_start_time = attributes_for(:reservation).except(:start_time)
      expect(Reservation.new(attrs_missing_start_time)).to be_invalid
    end

    it "is invalid with missing end_time" do
      attrs_missing_end_time = attributes_for(:reservation).except(:end_time)
      expect(Reservation.new(attrs_missing_end_time)).to be_invalid
    end

    it "is invalid with end_time previous to start_time" do
      start_time = DateTime.now
      end_time = start_time - 2
      reservation = Reservation.new(user: create(:user), start_time: start_time, end_time: end_time)
      expect(reservation).to be_invalid
    end
  end

  context "Associations" do
    let(:first_item) { create(:item) }
    let(:second_item) { create(:item) }
    let(:reservation) { create(:reservation) }

    it "is owned by a User" do
      user = create(:user)
      reservation = create(:reservation, :user => user)
      expect(user.reservations.include?(reservation)).to be(true)
    end
    
    it "has many Items" do
      reservation.items << first_item
      reservation.items << second_item
      expect(reservation.items).to eq([first_item, second_item])
      expect(reservation.items.count).to eq(2)
    end

    it "cannot have the same item twice" do
      reservation.items << first_item
      expect{ reservation.items << first_item }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
