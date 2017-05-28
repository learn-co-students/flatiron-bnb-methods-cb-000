class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :after_reservation

  private

  def after_reservation
    return unless reservation
    
    if reservation.status != 'accepted' || Date.today < reservation.checkout
      errors.add(:reservation, 'Reservation must have ended to leave a review.')
    end
  end
end
