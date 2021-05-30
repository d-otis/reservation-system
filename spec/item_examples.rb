RSpec.shared_examples "item examples" do
  let(:valid_item_attrs) do {
    :name => "M4 Audio Interface",
    :description => "Vestibulum id ligula porta felis euismod semper.",
    :serial_number => "xyz123"
  } end

  let(:item_missing_name) { valid_item_attrs.except(:name) }
end