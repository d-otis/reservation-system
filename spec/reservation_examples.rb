RSpec.shared_examples "reservation examples" do
  let(:valid_reservation_attrs) do {
    :note => "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Etiam porta sem malesuada magna mollis euismod.",
    :start_time => DateTime.now,
    :end_time => DateTime.now + 2
  } end

  let(:reservation_missing_note) { valid_reservation_attrs.except(:note) }
  let(:reservation_missing_start_time) { valid_reservation_attrs.except(:start_time) }
  let(:reservation_missing_end_time) { valid_reservation_attrs.except(:end_time) }
end