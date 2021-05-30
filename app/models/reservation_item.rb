class ReservationItem < ApplicationRecord
  belongs_to :reservation
  belongs_to :item

  validates_uniqueness_of :reservation_id, :scope => :item_id
end
