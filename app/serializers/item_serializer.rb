class ItemSerializer
  include JSONAPI::Serializer
  attributes :brand, :serial_number, :name, :description
end
