require 'rails_helper'
require 'item_examples'
require 'reservation_examples'
require 'user_examples'
require 'brand_examples'

RSpec.describe Item, type: :model do
  include_examples "item examples"
  include_examples "reservation examples"
  include_examples "user examples"
  include_examples "brand examples"

  let(:valid_item_attrs_with_brand) { valid_item_attrs.merge(brand: brand) }

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
    let(:item_missing_name) { valid_item_attrs_with_brand.except(:name) }
    let(:item_missing_description) { valid_item_attrs_with_brand.except(:description) }
    let(:item_missing_brand) { valid_item_attrs }
    let(:item_missing_serial_number) { valid_item_attrs.except(:serial_number) }

    it "is valid with valid attrs" do
      expect(Item.new(valid_item_attrs_with_brand)).to be_valid
    end

    it "is invalid without name" do
      expect(Item.new(item_missing_name)).to be_invalid
    end

    it "is invalid without description" do
      expect(Item.new(item_missing_description)).to be_invalid
    end

    it "is invalid without serial_number" do
      expect(Item.new(item_missing_serial_number)).to be_invalid
    end

    it "is invalid without brand" do
      expect(Item.new(item_missing_brand)).to be_invalid
    end
  end

  context "Associations" do
    it "belongs to a Brand" do
      item = Item.create(valid_item_attrs.merge(brand_id: brand.id))
      expect(item.brand).to eq(brand)
    end

    it "belongs to a Reservation" do
      reservation = test_user.reservations.create(valid_reservation_attrs)
      item = Item.create(valid_item_attrs_with_brand)
      item.reservations << reservation
      expect(item.reservations.include?(reservation)).to be(true)
      expect(item.reservations).to eq([reservation])
    end

    it "can belong to more than one Reservation" do
      reservation = test_user.reservations.create(valid_reservation_attrs)
      reservation_2 = test_user.reservations.create(valid_reservation_attrs)
      item = Item.create(valid_item_attrs_with_brand)
      item.reservations << reservation
      item.reservations << reservation_2
      expect(item.reservations.count).to eq(2)
      expect(item.reservations).to eq([reservation, reservation_2])
    end

    it "the same Item can only be added to a Reservation once" do
      reservation = test_user.reservations.create(valid_reservation_attrs)
      item = Item.create(valid_item_attrs_with_brand)
      reservation.items << item
      expect { reservation.items << item }.to raise_error(ActiveRecord::RecordInvalid )
    end
  end
end