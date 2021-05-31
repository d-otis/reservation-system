class User < ApplicationRecord
  has_many :reservations

  validates :email, :uniqueness => true, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates_inclusion_of :is_admin, in: [true, false]

  def full_name
    "#{first_name} #{last_name}"
  end
end
