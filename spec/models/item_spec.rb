require 'rails_helper'
require 'item_examples'

RSpec.describe Item, type: :model do
  include_examples "item examples"

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
    let(:brand) { Brand.new(name: "MOTU") }
    let(:valid_item_attrs_with_brand) { valid_item_attrs.merge(brand: brand) }
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
      brand = Brand.create(name: "MOTU")
      item = Item.create(valid_item_attrs.merge(brand_id: brand.id))
      expect(item.brand).to eq(brand)
    end
  end
end
