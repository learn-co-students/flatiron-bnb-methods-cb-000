class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :valid_reservation, :checked_out

  private

  def valid_reservation
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation is not valid, it must be accepted to leave a review.")
    end
  end

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation is still ongoing, it must have ended to add a review.")
    end
  end

end
