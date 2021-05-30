require 'rails_helper'
require 'item_examples'

RSpec.describe Brand, type: :model do
  include_examples "item examples"

  let(:valid_attrs) do {
    :name => "MOTU"
  } end

  context "Attributes" do
    it "has name attr" do
      expect(Brand.new).to respond_to(:name)
    end
  end

  context "Validations" do
    it "is valid w/ a name"
    it "is invalid w/o a name"
  end

  context "associations" do
    it "has many Items" do
      brand = Brand.create(valid_attrs)
      item = Item.create(valid_item_attrs.merge(brand: brand))
      expect(brand.items.count).to eq(1)
      expect(brand.items.include?(item)).to be(true)
    end
  end
end
