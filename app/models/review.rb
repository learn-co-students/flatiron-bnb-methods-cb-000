class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :has_reservation?
  validate :checkout_has_happened?
  
  def has_reservation?
    if !self.reservation
      errors.add(:reservation_id, "Must belong to a reservation")
    end
  end

  def checkout_has_happened?
    if self.reservation
      if self.reservation.checkout > Time.now
        errors.add(:reservation_id, "Checkout is in the future!")
      end
    end
  end
end
