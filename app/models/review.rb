class Review < ActiveRecord::Base
  belongs_to :reservation, required: true
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_accepted
  validate :checked_out


  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end



  def checked_out
   if reservation && reservation.checkout > Date.today
     errors.add(:reservation, "Reservation must have ended to leave a review.")
   end
 end

end
