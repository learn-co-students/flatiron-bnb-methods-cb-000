class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :trip_completed?


  private

  def trip_completed?
    unless self.rating.present? && self.description.present? && self.reservation.present? && self.reservation.checkout <= Date.current
      errors.add(:review, "Review must be completed after an accepted reservation")
    end
  end
end
