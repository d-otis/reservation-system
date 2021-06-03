class ReservationSerializer
  include JSONAPI::Serializer
  attributes :note, :start_time, :end_time, :user_id

  has_many :items
end
