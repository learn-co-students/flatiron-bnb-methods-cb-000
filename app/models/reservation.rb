class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true


  validate :checkin_not_checkout
  validate :checkout_before_checkin
  validate :own_reservation
  validate :listing_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price.to_i * duration
  end

  private

  def own_reservation
    if listing.host == guest
      errors.add(:listing, "Can't reserve your own listing")
    end
  end

  def listing_available
    if !listing.reservations.empty? && self.errors.empty?
      reservations = listing.reservations - listing.reservations.where(id: id)
      reservations.each do |res|
        booked = res.checkin..res.checkout
        if booked.include?(checkin) || booked.include?(checkout)
          errors.add(:guest, "Those dates are already booked")
        end
      end
    end
  end

  def checkin_not_checkout
    if !checkout.nil? && !checkin.nil?
      if checkin == checkout
        errors.add(:checkin, "Can't be the same as checkout")
        errors.add(:checkout, "Can't be the same as checkin")
      end
    end
  end

  def checkout_before_checkin
    if !checkout.nil? && !checkin.nil?
      if checkin > checkout
        errors.add(:checkout, "Must be after checkin")
      end
    end
  end

end
