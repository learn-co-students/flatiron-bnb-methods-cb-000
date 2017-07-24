class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :same_user
  validate :available
  validate :valid_checkin_date


  def same_user
    # Validates if listing host and guest are the same user
    if self.listing.host.id == self.guest_id
      errors.add(:guest_id, "The host and the guest cannot be the same user.")
    end
  end

  def available
    # check if the listing already has a reservation for the checkin date wanted
    all_reservations = Reservation.where(listing_id: self.listing_id)
    all_reservations.each do |reservation|
      if self.id == nil && (reservation.checkin..reservation.checkout).include?(self.checkin)
        errors.add(:checkin, "This date is not available for check in.")
      end
      if self.id == nil && (reservation.checkin..reservation.checkout).include?(self.checkout)
        errors.add(:checkin, "This date is not available for check out.")
      end
    end
  end

  def valid_checkin_date
    if (!self.checkin.nil? && !self.checkout.nil?) && (self.checkout <= self.checkin)
      errors.add(:checkin, "The check in date is after or the same as the check out date.")
    end
  end

  def duration
    (self.checkin..self.checkout).count - 1
  end

  def total_price
    price = self.listing.price.to_f
    price * duration
  end

end
