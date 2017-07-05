class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :res_accepted?, :checked_out?

  def res_accepted?
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "Reservation hasn't been accepted.")
    end
  end

  def checked_out?
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reviews can only entered once a reservation has ended.")
    end
  end
end
