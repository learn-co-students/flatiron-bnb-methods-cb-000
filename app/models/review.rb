class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validates :rating, numericality: { 
             greater_than_equal_to: 0,
             less_than_equal_to: 5,
             only_integer: true }

  validate :reservation_accepted_checked_out

  private
    def reservation_accepted_checked_out
      if reservation && reservation&.checkout > Date.today
        errors.add(:reservation, "Must wait till checkout to review")
      end
      if reservation&.status != "accepted" 
        errors.add(:reservation, "Reservation must be accepted to leave a review.")
      end
    end

end
