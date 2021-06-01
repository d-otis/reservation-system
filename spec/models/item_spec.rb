require 'rails_helper'

RSpec.describe Item, type: :model do
  context "Attributes" do
    it "has a name attr" do
      expect(Item.new).to respond_to(:name)
    end

    it "has a description attr" do
      expect(Item.new).to respond_to(:description)
    end

    it "has a serial_number attr" do
      expect(Item.new).to respond_to(:serial_number)
    end

    it "has a brand macro attr" do
      expect(Item.new).to respond_to(:brand)
    end

    it "has a brand_id attribute" do
      expect(Item.new).to respond_to(:brand_id)
    end
  end

  context "Validations" do
    it "is valid with valid attrs" do
      valid_item = build(:item)
      expect(valid_item).to be_valid
    end

    it "is invalid without name" do
      attrs_missing_name = attributes_for(:item).except(:name)
      expect(Item.new(attrs_missing_name)).to be_invalid
    end

    it "is invalid without description" do
      attrs_missing_description = attributes_for(:item).except(:description)
      expect(Item.new(attrs_missing_description)).to be_invalid
    end

    it "is invalid without serial_number" do
      attrs_missing_serial = attributes_for(:item).except(:serial_number)
      expect(Item.new(attrs_missing_serial)).to be_invalid
    end

    it "is invalid without brand" do
      attrs_missing_brand = attributes_for(:item).except(:brand)
      expect(Item.new(attrs_missing_brand)).to be_invalid
    end
  end

  context "Associations" do
    let(:item) { create(:item) }
    let(:brand) { item.brand }
    let(:first_reservation) { create(:reservation) }
    let(:second_reservation) { create(:reservation) }

    it "belongs to a Brand" do
      expect(item.brand).to eq(brand)
    end

    it "belongs to a Reservation" do
      item.reservations << first_reservation
      expect(item.reservations.include?(first_reservation)).to be(true)
      expect(item.reservations).to eq([first_reservation])
    end

    it "can belong to more than one Reservation" do
      item.reservations << first_reservation
      item.reservations << second_reservation
      expect(item.reservations.count).to eq(2)
      expect(item.reservations).to eq([first_reservation, second_reservation])
    end

    it "the same Item can only be added to a Reservation once" do
      first_reservation.items << item
      expect { first_reservation.items << item }.to raise_error(ActiveRecord::RecordInvalid )
    end
  end
end