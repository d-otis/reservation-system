require 'rails_helper'

RSpec.describe Brand, type: :model do
  context "Attributes" do
    it "has name attr" do
      expect(Brand.new).to respond_to(:name)
    end
  end

  context "Validations" do
    it "is valid w/ a name" do
      valid_attrs = attributes_for(:brand)
      expect(Brand.new(valid_attrs)).to be_valid
    end

    it "is invalid w/o a name" do
      expect(Brand.new).to be_invalid
    end
  end

  context "Associations" do
    it "has many Items" do
      brand = create(:brand)
      item = create(:item, :brand => brand)
      expect(brand.items.count).to eq(1)
      expect(brand.items.include?(item)).to be(true)
    end
  end
end
