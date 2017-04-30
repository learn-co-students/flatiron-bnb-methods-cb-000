class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :valid_checkout_checkin?, :is_guest_not_host?, :is_available?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def is_guest_not_host?
    if guest == listing.host
      errors.add(:guest_id, "You cannot book your own listing.")
    end
  end

  private

    def valid_checkout_checkin?
      if checkout && checkin && checkout <= checkin
        errors.add(:checkout , message: "Checkin must be done before checkout")
      end
    end

    def is_available?
      Reservation.where(listing_id: listing.id).where.not(id: id).each do |res| # Make sure reservation and listing id not same
        already_booked = res.checkin..res.checkout # set variable for booked range for reservation
        if  already_booked === checkin || already_booked === checkout # see if checkin or checkout range is already taken
          errors.add(:guest_id, "Selected dates are not available for reservation.")
        end
      end
    end

end
