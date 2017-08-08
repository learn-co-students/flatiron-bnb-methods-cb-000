class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true

  validate :legit_reservation, if: :reservation

  def legit_reservation
    if reservation.checkout && (reservation.checkout > DateTime.now || reservation.status != "accepted")
      errors.add( :reservation, "Cannot review the current reservation.")
    end
  end

end
