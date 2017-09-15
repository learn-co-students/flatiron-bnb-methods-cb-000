class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating,
            :description,
            :reservation,
            presence: true

  validate :checkout,
           :reservation_accepted

  def checkout
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended for review.")
    end
  end

  def reservation_accepted
    if reservation && reservation.status != 'accepted'
      errors.add(:reservation, "Reservation must be accepts to leave review.")
    end
  end
end
