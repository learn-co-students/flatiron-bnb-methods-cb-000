class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :accepted?, :after_reservation?, if: :reservation

  def accepted?
    if reservation.status != "accepted"
      errors.add(:reservation, "reservation was never accepted")
    end
  end

  def after_reservation?
    if reservation.checkout > Time.now
      errors.add(:reservation, "checkout has to have occurred")
    end
  end
end
