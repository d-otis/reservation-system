require 'rails_helper'

RSpec.describe Item, type: :model do

  let(:valid_attrs) do {
    :name => "M4 Audio Interface",
    :description => "Vestibulum id ligula porta felis euismod semper.",
    :serial_number => "xyz123"
  } end

  context "Attributes" do
    it "has a name attr"
    it "has a description attr"
    it "has a serial_number attr"
    it "has a brand attr"
  end

  context "Validations" do
    it "is valid with valid attrs"
    it "is invalid without name"
    it "is invalid without description"
    it "is invalid without serial_number"
    it "is invalid without brand_id"
  end

  context "Associations" do
    it "belongs to a Brand" do
      brand = Brand.create(name: "MOTU")
      item = Item.create(valid_attrs.merge(brand_id: brand.id))
      expect(item.brand).to eq(brand)
    end
  end
end
