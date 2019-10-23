class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :not_own_listing, :checkin_before_checkout, :listing_is_available

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def not_own_listing
    if listing.host_id == guest_id
      errors.add(:guest, "Cannot reserve your own listing!")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin.to_date >= checkout.to_date
      errors.add(:checkin, "Checkin must be before checkout!")
    end
  end

  def listing_is_available
    if checkin && checkout && !listing.is_available?(checkin, checkout)
      errors.add(:listing, "Listing is not available during those dates!")
    end
  end
end
