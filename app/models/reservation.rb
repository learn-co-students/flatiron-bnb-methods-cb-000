class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true
  validate :available, :checkout_after_checkin, :guest_and_host_not_same


  def duration
    (checkout - checkin).to_f
  end

  def total_price
    listing.price * duration
  end

  def to_s
    "#{listing.title}: #{checkin} to #{checkout}"
  end

  private


  def available
    (listing && listing.available?(checkin, checkout)) ||
      errors.add(:guest_id, "Sorry, listing not available in those dates")
  end

  def checkout_after_checkin
    (checkin && checkout && checkout > checkin) || 
      errors.add(:guest_id, "Checkout must be after checkin")
  end

  def guest_and_host_not_same
    (guest && listing.host && guest.id != listing.host.id) ||
      errors.add(:guest_id, "Guest and Host cannot be the same")
  end
end
