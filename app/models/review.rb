class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :valid_reservation

  private

  def valid_reservation
    if reservation
      if reservation.checkout > Date.today || reservation.status != "accepted"
        errors.add(:reservation, "invalid reservation for review")
      end
    end
  end

end
