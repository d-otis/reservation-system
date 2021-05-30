class Item < ApplicationRecord
  belongs_to :brand

  validates :name, :presence =>  true
  validates :description, :presence => true
  
end
