class Item < ApplicationRecord
  belongs_to :brand

  has_many :reservation_items
  has_many :reservations, :through => :reservation_items

  validates :name, :presence =>  true
  validates :description, :presence => true
end
