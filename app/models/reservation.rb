class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_not_equal_to_checkout
  validate :checkout_not_before_checkin
  validate :not_own_reservation
  validate :listing_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price.to_f * duration
  end

  private

  def not_own_reservation
    if listing.host == guest
      errors.add(:listing, "Can't reserve your own listing")
    end
  end

  def listing_available
    if !listing.reservations.empty? && self.errors.empty?
      reservations = listing.reservations - listing.reservations.where(id: id)
      reservations.each do |reservation|
        booked_dates = reservation.checkin..reservation.checkout
        if booked_dates.include?(checkin) || booked_dates.include?(checkout)
          errors.add(:guest, "Those dates are already booked")
        end
      end
    end
  end

  def checkin_not_equal_to_checkout
    if !checkout.nil? && !checkin.nil?
      if checkin == checkout
        errors.add(:checkin, "Can't be the same as checkout")
        errors.add(:checkout, "Can't be the same as checkin")
      end
    end
  end

  def checkout_not_before_checkin
    if !checkout.nil? && !checkin.nil?
      if checkin > checkout
        errors.add(:checkout, "Must be after checkin")
      end
    end
  end
  
end
