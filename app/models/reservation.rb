require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_own_listing, :available, :checkin_before_checkout

  def duration
    days = (checkout.day - checkin.day) + ((checkout.month - checkin.month)*30) + ((checkout.year - checkin.year)*365)
  end

  def total_price
    total_price = listing.price * duration
  end

  def not_own_listing
    if guest == listing.host
      errors.add(:listing, "you cannot book a listing you are hosting")
    end
  end


  def available
    Reservation.where(listing_id: listing_id).where.not(id: id).each do |r|
      date_range = r.checkin..r.checkout
      if date_range === self.checkin || date_range.include?(self.checkout)
        errors.add(:guest_id, "Sorry, this place isn't available during that time.")
      end
    end
  end

  def checkin_before_checkout
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Checkin must be before checkout.")
    end
  end
end
