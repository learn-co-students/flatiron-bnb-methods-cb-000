class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :self_reservation
  validate :available
  validate :checkout_after_checkin
  validate :checkin_not_checkout_dates

  def self_reservation
    if listing.host == guest
      errors.add(:guest_id, "Cannot book your own listing!")
    end
  end

  def available
    if (!checkin.nil? && !checkout.nil?)
      self.listing.reservations.each do |r|
        if (checkin <= r.checkout) && (checkout >= r.checkin)
          errors.add(:checkin, "listing is not available")
        end
        end
    end
  end

  def checkout_after_checkin
    if checkout && checkin && checkin > checkout
      errors.add(:guest_id, "Your checkout needs to be after your checkin.")
    end
  end

  def checkin_not_checkout_dates
    if checkin == checkout
      errors.add(:guest_id, "Your checkin and checkout dates cannot be the same.")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price.to_i * duration
  end

end
