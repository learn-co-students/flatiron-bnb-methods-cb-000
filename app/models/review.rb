class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :has_valid_reservation

  private

  def has_valid_reservation
    (!reservation.nil? and reservation.status == "accepted" and reservation.checkout < Date.today) ||
      errors.add(:guest_id, "Reservation not valid for review")
  end


end
