class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :different_users
  validate :availability
  validate :checkin_before_checkout

  def different_users
    if self.guest == self.listing.host
      errors.add(:guest_id, "Guest and host cannot be the same person")
    end
  end

  def availability
    if self.errors.blank?
      overlap = self.listing.reservations.any? do |reservation|
        (reservation.checkin <= self.checkout) && (reservation.checkout >= self.checkin)
      end
      if overlap
        errors.add(:listing_id, "Listing is already booked.")
      end
    end
  end

  def checkin_before_checkout
    if self.errors.blank? && (self.checkin >= self.checkout)
      errors.add(:checkin, "Check-in must be before Check-out.")
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

end
