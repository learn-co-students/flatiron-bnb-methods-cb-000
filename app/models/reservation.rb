class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :valid_checkout_checkin?, :is_guest_not_host?

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
        errors.add(:checkout , message: "Checkout must be before checkin")
      end
    end

end
