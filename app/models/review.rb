class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :reservation_status_must_be_accepted, :reservation_checkout_must_be_in_past

  private
  
  def reservation_status_must_be_accepted
    if self.reservation == nil || self.reservation.status != "accepted"
      errors.add(:status, "must be accepted")
    end
  end

  def reservation_checkout_must_be_in_past
    if self.reservation == nil || self.reservation.checkout >= Date.today
      errors.add(:checkout, "must have already happened")
    end
  end
end
