class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :visitor_is_not_host
  validate :listing_is_available_for_reservation

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price.to_i * duration
  end

  private

  def invalid_checkin_and_checkout_input
    errors.add(:reservation, "Invalid dates, please check and try again.") if checkin.nil? || checkout.nil? || checkin >= checkout
  end

  def listing_is_available_for_reservation
    unless invalid_checkin_and_checkout_input
      self.listing.reservations.each do |reservation|
        errors.add(:reservation, "This listing is booked those dates") if self.checkin <= reservation.checkout && self.checkout >= reservation.checkin
      end
    end
  end

  def visitor_is_not_host
    errors.add(:reservation, "You cannot be a guest of your own listings") if self.guest == self.listing.host
  end

end
