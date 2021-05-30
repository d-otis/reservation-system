class Reservation < ApplicationRecord
  belongs_to :user

  has_many :reservation_items
  has_many :items, :through => :reservation_items

  validates :start_time, :end_time, :presence => true
  validate :end_after_start

  private

  def end_after_start
    return if start_time.blank? || end_time.blank?
    if start_time > end_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
