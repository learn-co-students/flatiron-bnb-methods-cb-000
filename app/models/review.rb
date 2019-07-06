class Review < ActiveRecord::Base
  belongs_to :reservation, required: true
  belongs_to :guest, :class_name => "User"

  # Validation
  validates :rating, presence: true, numericality: {
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 5,
        only_integer: true
  }
  validates :description, presence: true
  validates :reservation_id, presence: true

  validate :check_out
  validate :reservation_accepted
  private

  def check_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end

  def reservation_accepted

  end

end
