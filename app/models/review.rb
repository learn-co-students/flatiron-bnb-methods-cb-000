class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :res_after_checkout_and_accepted

  def res_after_checkout_and_accepted
    if reservation
      errors.add(:reservation, "must be completed")  if reservation.checkout >= DateTime.now
      errors.add(:reservation, "must be accepted") if reservation.status != "accepted"
    end
  end

end
