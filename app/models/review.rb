class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validate :needs_reservation
  validates :rating, :description, :reservation_id, presence: true


  private
  def needs_reservation
    if self.reservation == nil
      errors.add(:reservation_id, "needs a reservation")
    elsif !(self.reservation.status == "accepted")
      errors.add(:reservation_id, "reservation needs to be accepted")
    elsif self.reservation.checkout >= Date.today
      errors.add(:rating,  "rating can only be given after reservation checkout date")
    end
  end

end
