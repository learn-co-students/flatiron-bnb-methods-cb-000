class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :reservation_has_passed

  def reservation_has_passed
    if !self.reservation_id.nil? && self.reservation.checkout > Date.today
      errors.add(:reservation_id, "Cannot enter a review before the checkout date.")
    end
  end
end
