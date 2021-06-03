class UserSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email, :is_admin, :reservations

  has_many :reservations
end
