RSpec.shared_examples "item examples" do
  let(:valid_item_attrs) do {
    :name => "M4 Audio Interface",
    :description => "Vestibulum id ligula porta felis euismod semper.",
    :serial_number => "xyz123"
  } end

  let(:more_valid_item_attrs) do {
    :name => "SM58 Microphone",
    :description => "Nulla vitae elit libero, a pharetra augue.",
    :serial_number => "123xyz"
  } end

  let(:item_missing_name) { valid_item_attrs.except(:name) }
end